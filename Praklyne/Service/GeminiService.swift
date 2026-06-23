import Foundation

// MARK: - Gemini API Service
final class GeminiService: ObservableObject {

    // ⚠️ Replace this with your actual API key if you rotate it
    static let apiKey = "AIzaSyAQ.Ab8RN6I_r0IwAAaWeJQcJ8IdbbArIQb6wqfP1bvUUWLUYSiQiQ"

    private let model = "gemini-1.5-flash"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models"

    // Educational system prompt — keeps the AI focused on learning
    private let systemInstruction = """
    You are Praklyne AI, a friendly and encouraging educational assistant embedded inside the Praklyne learning app. \
    Your role is to help students learn subjects like Science, Mathematics, English, Programming, and Business. \
    You explain concepts clearly, give real-world examples, and can quiz students. \
    You also help with English grammar, vocabulary, and writing. \
    If the student writes in Sinhala, you can understand and reply in both Sinhala and English. \
    Always be encouraging, patient, and use simple language. \
    Keep answers concise unless the student asks for detail. \
    Do NOT discuss unrelated topics. Focus only on education and learning.
    """

    // MARK: - Message history for multi-turn conversation
    struct GeminiMessage {
        let role: String   // "user" or "model"
        let text: String
    }

    func sendMessage(
        history: [GeminiMessage],
        newMessage: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let urlString = "\(baseURL)/\(model):generateContent?key=\(GeminiService.apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(GeminiError.invalidURL))
            return
        }

        // Build contents array including full history
        var contents: [[String: Any]] = []

        for msg in history {
            contents.append([
                "role": msg.role,
                "parts": [["text": msg.text]]
            ])
        }
        // Append the new user message
        contents.append([
            "role": "user",
            "parts": [["text": newMessage]]
        ])

        let body: [String: Any] = [
            "system_instruction": [
                "parts": [["text": systemInstruction]]
            ],
            "contents": contents,
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 1024
            ]
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(GeminiError.encodingFailed))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        request.timeoutInterval = 30

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(GeminiError.noData))
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let candidates = json["candidates"] as? [[String: Any]],
                       let first = candidates.first,
                       let content = first["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]],
                       let text = parts.first?["text"] as? String {
                        completion(.success(text))
                    } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let error = json["error"] as? [String: Any],
                              let message = error["message"] as? String {
                        completion(.failure(GeminiError.apiError(message)))
                    } else {
                        completion(.failure(GeminiError.unexpectedResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

// MARK: - Errors
enum GeminiError: LocalizedError {
    case invalidURL
    case encodingFailed
    case noData
    case unexpectedResponse
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:         return "Invalid API URL."
        case .encodingFailed:     return "Failed to encode request."
        case .noData:             return "No data received from server."
        case .unexpectedResponse: return "Unexpected response format."
        case .apiError(let msg):  return "API Error: \(msg)"
        }
    }
}
