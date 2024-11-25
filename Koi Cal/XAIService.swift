import Foundation

class XAIService: ObservableObject {
    @Published var isLoading = false
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    struct ChatRequest: Codable {
        let messages: [Message]
        let model: String
        let stream: Bool
        let temperature: Double
    }
    
    struct ChatResponse: Codable {
        let message: Message
    }
    
    func getRecommendation(
        temperature: Double,
        fishAge: String,
        objective: String,
        foodType: String,
        location: String
    ) async throws -> String {
        let prompt = XAIConfig.systemPrompt
            .replacingOccurrences(of: "{temp}", with: String(format: "%.0f", temperature))
            .replacingOccurrences(of: "{age}", with: fishAge)
            .replacingOccurrences(of: "{objective}", with: objective)
            .replacingOccurrences(of: "{foodType}", with: foodType)
            .replacingOccurrences(of: "{location}", with: location)
        
        let messages = [
            Message(role: "system", content: prompt),
            Message(role: "user", content: "What is your feeding recommendation for today?")
        ]
        
        let request = ChatRequest(
            messages: messages,
            model: "grok-beta",
            stream: false,
            temperature: 0.7
        )
        
        var urlRequest = URLRequest(url: URL(string: XAIConfig.apiURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(XAIConfig.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(ChatResponse.self, from: data)
        
        return response.message.content
    }
} 