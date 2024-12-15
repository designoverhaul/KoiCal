import Foundation

@MainActor
class XAIService: ObservableObject {
    @Published private(set) var isLoading = false
    private var currentTaskID = 0
    
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
        let choices: [Choice]
    }
    
    struct Recommendations {
        let feedingFrequency: String
        let foodType: String
        let pondReport: String
        let concernRecommendations: [String: String]
    }
    
    func getRecommendation(
        temperature: Double,
        fishAge: String,
        improveColor: Bool,
        growthAndBreeding: Bool,
        improvedBehavior: Bool,
        sicknessDeath: Bool,
        lowEnergy: Bool,
        stuntedGrowth: Bool,
        lackAppetite: Bool,
        obesityBloating: Bool,
        constantHiding: Bool,
        location: String,
        waterTest: String,
        pondSize: String,
        fishCount: String, 
        feedingHistory: String,
        waterClarity: Int,
        waterClarityText: String
    ) async throws -> Recommendations {
        print("\n🚀 === Starting XAI Request ===")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let currentDate = dateFormatter.string(from: Date())
        
        var selectedConcerns: [String] = []
        if sicknessDeath { selectedConcerns.append("Sickness or death") }
        if lowEnergy { selectedConcerns.append("Low energy") }
        if stuntedGrowth { selectedConcerns.append("Stunted growth") }
        if lackAppetite { selectedConcerns.append("Lack of appetite") }
        if obesityBloating { selectedConcerns.append("Obesity/bloating") }
        if constantHiding { selectedConcerns.append("Constant hiding") }
        if waterClarity > 0 {
            selectedConcerns.append(waterClarityText.replacingOccurrences(of: " ", with: ""))
        }

        let concernsPrompt = selectedConcerns.isEmpty ? "" : 
            "\n\nFor each of these specific concerns, provide targeted advice:\n" + 
            selectedConcerns.joined(separator: "\n")

        let messages = [
            Message(role: "system", content: XAIConfig.systemPrompt),
            Message(role: "user", content: """
                The current date is \(currentDate).
                Temperature: \(temperature)
                Fish Age: \(fishAge)
                PondLocation: \(location)
                Water Test: \(waterTest)
                Pond Size: \(pondSize)
                Fish Count: \(fishCount)
                Feeding History: \(feedingHistory)
                
                Goals:
                - Improve Color: \(improveColor)
                - Growth and Breeding: \(growthAndBreeding)
                - Improved Behavior: \(improvedBehavior)
                
                Problems:
                - Sickness/Death: \(sicknessDeath)
                - Low Energy: \(lowEnergy)
                - Stunted Growth: \(stuntedGrowth)
                - Lack Appetite: \(lackAppetite)
                - Obesity/Bloating: \(obesityBloating)
                - Constant Hiding: \(constantHiding)
                
                Provide three recommendations:
                1. FOOD TYPE: Recommend the appropriate food type.
                2. FEEDING FREQUENCY: Provide the feeding frequency in the specified format.
                3. POND REPORT: Analyze water test results and provide recommendations.
                
                Format your response exactly like this:
                FOOD TYPE: [your recommendation]
                FEEDING FREQUENCY: [your recommendation]
                POND REPORT: [your analysis and recommendations]
                
                \(selectedConcerns.isEmpty ? "" : "\nThen provide specific advice for each concern:")
                \(selectedConcerns.map { concern in 
                    """
                    
                    CONCERN: \(concern)
                    ADVICE: [Provide specific recommendation for \(concern)]
                    """
                }.joined(separator: "\n"))
                """)
        ]
        
        print("\n📤 Request Messages:")
        print(messages.map { "[\($0.role)]: \($0.content)" }.joined(separator: "\n"))
        
        let request = ChatRequest(
            messages: messages,
            model: "grok-beta",
            temperature: 0.6,
            max_tokens: 250
        )
        
        var urlRequest = URLRequest(url: URL(string: XAIConfig.apiURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(XAIConfig.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
            print("\n📡 API URL: \(XAIConfig.apiURL)")
            print("📝 Request Body:")
            if let requestStr = String(data: urlRequest.httpBody!, encoding: .utf8) {
                print(requestStr)
            }
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\n📡 Response Status: \(httpResponse.statusCode)")
            }
            
            print("\n📥 Raw Response:")
            print(String(data: data, encoding: .utf8) ?? "Could not decode response")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ API Error: \(String(data: data, encoding: .utf8) ?? "No error details")")
                throw NSError(domain: "XAIService", code: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            
            let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
            print("\n📥 AI Response:")
            print(String(data: data, encoding: .utf8) ?? "Could not read response")
            
            let recommendation = chatResponse.choices.first?.message.content ?? "No recommendation available"
            let lines = recommendation.components(separatedBy: .newlines)
            
            var foodType = "No food type recommendation available"
            var feedingFrequency = "No feeding recommendation available"
            var pondReport = "No pond report available"
            var capturingPondReport = false
            var concernRecommendations: [String: String] = [:]
            var currentConcern = ""
            
            for line in lines {
                if line.starts(with: "FOOD TYPE:") {
                    foodType = line.replacingOccurrences(of: "FOOD TYPE:", with: "").trimmingCharacters(in: .whitespaces)
                    capturingPondReport = false
                } else if line.starts(with: "FEEDING FREQUENCY:") {
                    feedingFrequency = line.replacingOccurrences(of: "FEEDING FREQUENCY:", with: "").trimmingCharacters(in: .whitespaces)
                    capturingPondReport = false
                } else if line.starts(with: "POND REPORT:") {
                    pondReport = line.replacingOccurrences(of: "POND REPORT:", with: "").trimmingCharacters(in: .whitespaces)
                    capturingPondReport = true
                } else if capturingPondReport && !line.isEmpty && !line.starts(with: "CONCERN:") {
                    pondReport += "\n" + line.trimmingCharacters(in: .whitespaces)
                } else if line.starts(with: "CONCERN:") {
                    capturingPondReport = false
                    currentConcern = line.replacingOccurrences(of: "CONCERN:", with: "").trimmingCharacters(in: .whitespaces)
                } else if line.starts(with: "ADVICE:") {
                    let advice = line.replacingOccurrences(of: "ADVICE:", with: "").trimmingCharacters(in: .whitespaces)
                    if !currentConcern.isEmpty {
                        concernRecommendations[currentConcern] = advice
                        currentConcern = ""
                    }
                }
            }
            
            return Recommendations(
                feedingFrequency: feedingFrequency,
                foodType: foodType,
                pondReport: pondReport,
                concernRecommendations: concernRecommendations
            )
        } catch {
            print("❌ ERROR: \(error)")
            throw error
        }
    }
} 