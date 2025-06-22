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
        fishSize: String,
        improveColor: Bool,
        growthAndBreeding: Bool,
        improvedBehavior: Bool,
        sicknessDeath: Bool,
        lowEnergy: Bool,
        stuntedGrowth: Bool,
        lackAppetite: Bool,
        obesityBloating: Bool,
        constantHiding: Bool,
        flukes: Bool,
        location: String,
        waterTest: String,
        pondSize: String,
        fishCount: String,
        feedingHistory: String,
        waterClarity: Int,
        waterClarityText: String,
        useMetric: Bool,
        circulationTime: String
    ) async throws -> Recommendations {
        print("\n🚀 === Starting XAI Request ===")
        // Read salinity from AppStorage - Note: This service ideally shouldn't directly access AppStorage.
        // A better approach would be to pass salinity as a parameter like other values.
        // For now, we'll read it here for simplicity based on the current pattern.
        let salinityPercent = UserDefaults.standard.double(forKey: "salinityPercent") // Reads 0.0 if not set
        let salinityString = String(format: "%.2f%%", salinityPercent)

        print("Received waterTest string:")
        print(waterTest)
        
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
        if flukes { selectedConcerns.append("Flukes") }

        var activeGoals: [String] = []
        if improveColor { activeGoals.append("Improve Color") }
        if growthAndBreeding { activeGoals.append("Growth and Breeding") }
        if improvedBehavior { activeGoals.append("Improved Behavior") }

        let goalsSection = activeGoals.isEmpty ? "" : """
            
            Goals:
            \(activeGoals.map { "- \($0)" }.joined(separator: "\n"))
            """

        let problemsSection = selectedConcerns.isEmpty ? "" : """
            
            Problems:
            \(selectedConcerns.map { "- \($0)" }.joined(separator: "\n"))
            """

        let messages = [
            Message(role: "system", content: XAIConfig.systemPrompt),
            Message(role: "user", content: """
                The current date is \(currentDate).
                Sunlight adjusted water temp: \(String(format: "%.0f°F", temperature))
                Fish Age: \(fishAge)
                Fish Size: \(fishSize)
                PondLocation: \(location)
                \(waterTest)
                Pond Size: \(pondSize) \(useMetric ? "liters" : "gallons")
                Fish Count: \(fishCount)
                Circulation Rate: \(circulationTime) seconds per \(useMetric ? "liter" : "gallon")
                Salinity: \(salinityString) (safe range for koi is 0.0-0.3%)
                
                // Add detailed circulation calculation instructions
                CIRCULATION CALCULATION INSTRUCTIONS:
                The entire pond should circulate in an hour. 
                Calculate if circulation is adequate based on pond size and seconds to fill a gallon/liter.
                Example: A 1000 gallon pond should take 3.6 seconds to fill a 1 gallon container (3600 seconds ÷ 1000 gallons = 3.6 seconds per gallon).
                Include in the pond report whether circulation is adequate or needs to be increased.
                
                Feeding History: \(feedingHistory)
                \(goalsSection)
                \(problemsSection)
                
                Provide these recommendations in the exact format shown, keeping responses brief and focused:
                
                FOOD TYPE: [One or two sentences. Never recommend high protein in Nov-Feb. Check feeding history for overfeeding.]
                
                FEEDING FREQUENCY: [One sentence about feeding frequency considering location, date, and temperature]
                
                POND REPORT: [Maximum three key points about pond health. Check all user input for potential problems and reference user's information.]
                
                \(waterClarity > 0 ? """
                CONCERN: \(waterClarityText)
                ADVICE: [Two sentences maximum addressing this water clarity issue. Consider ALL user input.]
                """ : "")
                
                \(selectedConcerns.isEmpty ? "" : "\nFor each concern, provide a focused two-sentence recommendation:")
                \(selectedConcerns.map { concern in 
                    """
                    
                    CONCERN: \(concern)
                    ADVICE: [Two sentences maximum addressing the specific concern. First check for problems based on the user's input.]
                    """
                }.joined(separator: "\n"))
                """)
        ]
        
        print("\n📤 Request Messages:")
        print(messages.map { "[\($0.role)]: \($0.content)" }.joined(separator: "\n"))
        
        let request = ChatRequest(
            messages: messages,
            model: "grok-3",
            temperature: 0.6,
            max_tokens: 500
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
                let cleanLine = line.replacingOccurrences(of: "**", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                if cleanLine.starts(with: "FOOD TYPE:") {
                    foodType = cleanLine.replacingOccurrences(of: "FOOD TYPE:", with: "").trimmingCharacters(in: .whitespaces)
                } else if cleanLine.starts(with: "FEEDING FREQUENCY:") {
                    feedingFrequency = cleanLine.replacingOccurrences(of: "FEEDING FREQUENCY:", with: "").trimmingCharacters(in: .whitespaces)
                } else if cleanLine.starts(with: "POND REPORT:") {
                    pondReport = cleanLine.replacingOccurrences(of: "POND REPORT:", with: "").trimmingCharacters(in: .whitespaces)
                    capturingPondReport = true
                } else if capturingPondReport && !cleanLine.isEmpty && !cleanLine.starts(with: "CONCERN:") {
                    pondReport += "\n" + cleanLine.trimmingCharacters(in: .whitespaces)
                } else if cleanLine.starts(with: "CONCERN:") {
                    capturingPondReport = false
                    currentConcern = cleanLine.replacingOccurrences(of: "CONCERN:", with: "").trimmingCharacters(in: .whitespaces)
                } else if cleanLine.starts(with: "ADVICE:") {
                    let advice = cleanLine.replacingOccurrences(of: "ADVICE:", with: "").trimmingCharacters(in: .whitespaces)
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
