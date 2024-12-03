//
//  SummarizerService.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 2.12.2024.
//

import Foundation

class SummarizerService {
    let baseURL = "http://185.172.57.105:8000/summarizer/youtube"
    
    func fetchSummary(videoUrl: String, langCode: String, completion: @escaping (Result<SummarizerResponse, Error>) -> Void) {
        // API için URL oluşturma
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // JSON body oluşturma
        let requestBody = SummarizerRequest(videoUrl: videoUrl, langCode: langCode)
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            completion(.failure(NSError(domain: "Invalid JSON body", code: -2, userInfo: nil)))
            return
        }
        
        // URLRequest oluşturma
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // URLSession kullanarak isteği yapma
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: -3, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -4, userInfo: nil)))
                return
            }
            
            // JSON parsing
            do {
                let response = try JSONDecoder().decode(SummarizerResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
