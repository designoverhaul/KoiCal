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
    
    func getRecommendation(
        temperature: Double,
        fishAge: String,
        objective: String,
        location: String,
        feedingHistory: String
    ) async throws -> String {
        await MainActor.run {
            isLoading = true
        }
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let prompt = XAIConfig.systemPrompt
            .replacingOccurrences(of: "{temp}", with: String(format: "%.0f", temperature))
            .replacingOccurrences(of: "{age}", with: fishAge)
            .replacingOccurrences(of: "{objective}", with: objective)
            .replacingOccurrences(of: "{location}", with: location)
            .replacingOccurrences(of: "{feeding_history}", with: feedingHistory)
        
        let messages = [
            Message(role: "system", content: prompt),
            Message(role: "user", content: "What is your feeding recommendation for today?")
        ]
        
        let request = ChatRequest(
            messages: messages,
            model: "grok-beta",
            temperature: 0.7,
            max_tokens: 100
        )
        
        var urlRequest = URLRequest(url: URL(string: XAIConfig.apiURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(XAIConfig.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("API Response Status: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response Body: \(responseString)")
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NSError(domain: "XAIService",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to get recommendation"])
            }
        }
        
        let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
        return chatResponse.choices.first?.message.content ?? "No recommendation available"
    }
} 