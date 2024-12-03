//
//  YouTubeThumbnailFetcher.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 26.11.2024.
//

import UIKit

class YouTubeThumbnailFetcher {

    // YouTube video ID'den thumbnail URL oluşturma
    func getThumbnailURL(from youtubeLink: String) -> URL? {
        guard let videoID = extractVideoID(from: youtubeLink) else { return nil }
        let thumbnailURLString = "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg"
        return URL(string: thumbnailURLString)
    }
    
    // YouTube linkinden video ID'sini çıkartma
    private func extractVideoID(from youtubeLink: String) -> String? {
        // Eğer link "youtu.be" formatında ise
        if youtubeLink.contains("youtu.be") {
            return youtubeLink.split(separator: "/").last?.split(separator: "?").first.map(String.init)
        }
        
        // Eğer link "youtube.com" formatında ise
        if let url = URL(string: youtubeLink), let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
            return queryItems.first(where: { $0.name == "v" })?.value
        }
        
        return nil
    }

    // Görsel indir ve ana rengini hesapla
    func fetchThumbnailAndColor(from youtubeLink: String, completion: @escaping (UIImage?, UIColor?) -> Void) {
        guard let thumbnailURL = getThumbnailURL(from: youtubeLink) else {
            completion(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: thumbnailURL) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil, nil)
                return
            }
            
            let dominantColor = self.extractDominantColor(from: image)
            completion(image, dominantColor)
        }
        task.resume()
    }
    
    // Ana renk çıkarma işlemi
    private func extractDominantColor(from image: UIImage) -> UIColor? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let parameters = [kCIInputImageKey: ciImage]
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: parameters) else { return nil }
        
        let extent = ciImage.extent
        let bitmap = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        defer { bitmap.deallocate() }
        
        let context = CIContext(options: nil)
        context.render(filter.outputImage!, toBitmap: bitmap, rowBytes: 4, bounds: extent, format: .RGBA8, colorSpace: nil)
        
        let red = CGFloat(bitmap[0]) / 255.0
        let green = CGFloat(bitmap[1]) / 255.0
        let blue = CGFloat(bitmap[2]) / 255.0
        let alpha = CGFloat(bitmap[3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
