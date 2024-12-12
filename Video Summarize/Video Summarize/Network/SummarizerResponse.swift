//
//  SummarizerResponse.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 2.12.2024.
//

import Foundation

struct SummarizerRequest: Codable {
    let videoUrl: String
    let langCode: String
}

struct SummarizerResponse: Codable {
    let videoId: String?
    let message: String?
    let summary: String?
    let thumbnail: String?
    let title: String?
    let duration: Int?
    let createdAt: Date?
    let langCode: String?
}

struct Updated: Codable {
    var isEnable: Bool
    var iosVersion: String
    var androidVersion: String
    
    enum CodingKeys: String, CodingKey {
        case isEnable = "is_enable"
        case iosVersion
        case androidVersion
    }

    init(isEnable: Bool = false, iosVersion: String = "", androidVersion: String = "") {
        self.isEnable = isEnable
        self.iosVersion = iosVersion
        self.androidVersion = androidVersion
    }
}




class ResponseManager {
    static let shared = ResponseManager()
    
    private let responsesKey = "SavedResponses"
    
    // Response'u diziye ekle ve sakla
    func saveResponse(_ response: SummarizerResponse, createdAt: Date?, langCode: String?) {
        var responses = getResponses() // Mevcut dizi

        // Varsayılan değerler belirliyoruz
        let defaultDate = createdAt ?? Date() // Tarih yoksa şu anki tarihi kullan
        let defaultLangCode = langCode ?? "unknown" // Dil kodu yoksa 'unknown' kullan

        // Yeni yanıtın tarihini ve dil kodunu ekliyoruz
        let responseWithDate = SummarizerResponse(
            videoId: response.videoId,
            message: response.message,
            summary: response.summary,
            thumbnail: response.thumbnail,
            title: response.title,
            duration: response.duration,
            createdAt: defaultDate, // Varsayılan tarihi ekle
            langCode: defaultLangCode // Varsayılan dil kodunu ekle
        )

        responses.append(responseWithDate) // Yeni response'u ekle
        if let data = try? JSONEncoder().encode(responses) {
            UserDefaults.standard.set(data, forKey: responsesKey)
        }
    }

       
       // Kaydedilmiş response'ların tümünü al (En yeni ilk gelecek şekilde sıralanır)
       func getResponses() -> [SummarizerResponse] {
           if let data = UserDefaults.standard.data(forKey: responsesKey),
              let responses = try? JSONDecoder().decode([SummarizerResponse].self, from: data) {
               return responses.sorted { $0.createdAt ?? Date()  > $1.createdAt ?? Date() } // En yeni ilk
           }
           return [] // Varsayılan boş dizi
       }
       
       // Bir yanıtı sil
       func removeResponse(at index: Int) {
           var responses = getResponses()
           if responses.indices.contains(index) {
               responses.remove(at: index) // Diziden sil
               if let data = try? JSONEncoder().encode(responses) {
                   UserDefaults.standard.set(data, forKey: responsesKey) // Güncel diziyi sakla
               }
           }
       }
       
       // Video ID ile bir yanıtı güncelle
       func updateResponse(for videoId: String, with updatedResponse: SummarizerResponse) {
           var responses = getResponses()
           if let index = responses.firstIndex(where: { $0.videoId == videoId }) {
               responses[index] = updatedResponse // Yanıtı güncelle
               if let data = try? JSONEncoder().encode(responses) {
                   UserDefaults.standard.set(data, forKey: responsesKey) // Güncellenmiş diziyi sakla
               }
           }
       }
    
    func getResponsesStatistics() -> (totalDurationInMinutes: Int, totalWordCountInSummary: Int) {
        let responses = getResponses() // Mevcut metodunuz çağrılıyor
        
        // Toplam süre (dakika cinsine dönüştürerek)
        let totalDuration = responses.reduce(0) { $0 + ($1.duration ?? 0) } / 60
        
        // Summary'deki toplam kelime sayısı
        let totalWordCount = responses.reduce(0) { $0 + ($1.summary?.split(separator: " ").count ?? 0) }
        
        return (totalDuration, totalWordCount)
    }

}
