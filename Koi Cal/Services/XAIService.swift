import Foundation

class XAIService: ObservableObject {
    @Published var isLoading = false
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    struct Choice: Codable {
        let index: Int
        let message: Message
        let finish_reason: String
    }
    
    struct ChatRequest: Codable {
        let messages: [Message]
        let model: String
        let temperature: Double
        let max_tokens: Int
    }
    
    struct ChatResponse: Codable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let choices: [Choice]
        let usage: Usage
    }
    
    struct Usage: Codable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
    
    struct Recommendations {
        let feedingFrequency: String
        let foodType: String
        let pondReport: String
    }
    
    func getRecommendation(
        temperature: Double,
        fishAge: String,
        objective: String,
        location: String,
        feedingHistory: String
    ) async throws -> Recommendations {
        await MainActor.run {
            isLoading = true
        }
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        // Get current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let currentDate = dateFormatter.string(from: Date())
        
        // Debug: Print input values
        print("🔍 Input Values:")
        print("Current Date: \(currentDate)")
        print("Temperature: \(temperature)")
        print("Fish Age: \(fishAge)")
        print("Objective: \(objective)")
        print("Location: \(location)")
        print("Feeding History: \(feedingHistory)")
        
        let prompt = XAIConfig.systemPrompt
            .replacingOccurrences(of: "{temp}", with: String(format: "%.0f", temperature))
            .replacingOccurrences(of: "{age}", with: fishAge)
            .replacingOccurrences(of: "{objective}", with: objective)
            .replacingOccurrences(of: "{location}", with: location)
            .replacingOccurrences(of: "{feeding_history}", with: feedingHistory)
        
        // Debug: Print the complete system prompt
        print("\n🤖 System Prompt:")
        print(prompt)
        
        let messages = [
            Message(role: "system", content: prompt),
            Message(role: "user", content: """
                The current date is \(currentDate). 
                Provide three recommendations:
                1. FOOD TYPE: Recommend the appropriate food type.
                2. FEEDING FREQUENCY: Provide the feeding frequency in the specified format.
                3. POND REPORT: Analyze water test results and provide recommendations.
                
                Format your response exactly like this:
                FOOD TYPE: [your recommendation]
                FEEDING FREQUENCY: [your recommendation]
                POND REPORT: [your analysis and recommendations]
                """)
        ]
        
        // Debug: Print the complete request
        print("\n📤 Request to XAI:")
        let request = ChatRequest(
            messages: messages,
            model: "grok-beta",
            temperature: 0.7,
            max_tokens: 300
        )
        
        if let requestJson = try? JSONEncoder().encode(request),
           let requestString = String(data: requestJson, encoding: .utf8) {
            print(requestString)
        }
        
        var urlRequest = URLRequest(url: URL(string: XAIConfig.apiURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(XAIConfig.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("\n📥 Response Status: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body:")
                print(responseString)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NSError(domain: "XAIService",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to get recommendation"])
            }
        }
        
        let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
        let recommendation = chatResponse.choices.first?.message.content ?? "No recommendation available"
        
        // Debug: Print final recommendation
        print("\n🎯 Final Recommendation:")
        print(recommendation)
        
        let lines = recommendation.components(separatedBy: .newlines)
        
        var foodType = "No food type recommendation available"
        var feedingFrequency = "No feeding recommendation available"
        var pondReport = "No pond report available"
        
        for line in lines {
            if line.starts(with: "FOOD TYPE:") {
                foodType = line.replacingOccurrences(of: "FOOD TYPE:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.starts(with: "FEEDING FREQUENCY:") {
                feedingFrequency = line.replacingOccurrences(of: "FEEDING FREQUENCY:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.starts(with: "POND REPORT:") {
                pondReport = line.replacingOccurrences(of: "POND REPORT:", with: "").trimmingCharacters(in: .whitespaces)
            }
        }
        
        return Recommendations(
            feedingFrequency: feedingFrequency,
            foodType: foodType,
            pondReport: pondReport
        )
    }
} 