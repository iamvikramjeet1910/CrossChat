//
//  TranslationService.swift
//  CrossChat
//
//  Created by Vikram Kumar on 29/05/25.
//

import Foundation

class TranslationService {
    let apiKey = "AIzaSyDyON3YX9FUcglJ_89DCRQDCJX6T4PGvCQ" // Replace with your API key

    func translate(text: String, fromLanguage: String, toLanguage: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for translation API")
            completion(nil)
            return
        }

        let body = [
            "q": text,
            "source": fromLanguage,
            "target": toLanguage,
            "format": "text"
        ]

        // Encode body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to encode JSON body")
            completion(nil)
            return
        }

        // Setup URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Perform API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during translation: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data,
                  let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let translations = (responseJson["data"] as? [String: Any])?["translations"] as? [[String: Any]],
                  let translatedText = translations.first?["translatedText"] as? String else {
                print("Invalid response from translation API")
                completion(nil)
                return
            }

            print("Translation successful: \(translatedText)")
            completion(translatedText)
        }.resume()
    }
}
