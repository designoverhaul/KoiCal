import Foundation

enum XAIConfig {
    static let apiKey = "xai-XmftRnCF8xgNeIGc571IR8wYbMpzLO9wcEJFCRAqe6vDlhdQHoZDChlzNwCsiJO3TkOKtNUwoD5hJ9vH"
    static let apiURL = "https://api.x.ai/v1/chat/completions"
    
    static let systemPrompt = """
    You are a koi fish feeding expert. Based on these conditions:
    - Current temperature: {temp}°F
    - Fish age: {age}
    - Primary objective: {objective}
    - Location: {location}
    
    Provide ONE brief sentence recommending feeding frequency and amount for today only.
    Focus on practical advice considering temperature, fish age, and objectives.
    """
} 