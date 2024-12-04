//
//  ShareViewController.swift
//  shareVideo
//
//  Created by Ahmet Muhammet VURAL on 3.12.2024.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIButton!{
        didSet {
            shareButton.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 18)!
            shareButton.setTitle(Text.summary, for: .normal)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.font = UIFont(name: "SFProRounded-Bold", size: 24)!
            titleLabel.text = "YouTube Summarize"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        extractSharedContent()
    }
    
    @IBAction func share(_ sender: Any) {
        if let appURL = URL(string: "youtubeSummarize://") {
            openURL(appURL)
        }
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    @objc @discardableResult private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                if #available(iOS 18.0, *) {
                    application.open(url, options: [:], completionHandler: nil)
                    return true
                } else {
                    return application.perform(#selector(openURL(_:)), with: url) != nil
                }
            }
            responder = responder?.next
        }
        return false
    }
    
    private func extractSharedContent() {
           // Paylaşma içeriğini al
           guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
               print("Extension item bulunamadı.")
               return
           }
           
           // Ekleri kontrol et
           guard let attachments = extensionItem.attachments else {
               print("Attachments bulunamadı.")
               return
           }
           
           // Ekleri döngüyle kontrol et
           for attachment in attachments {
               // URL'yi işleme
               if attachment.hasItemConformingToTypeIdentifier("public.url") {
                   attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (data, error) in
                       if let error = error {
                           print("URL yüklenirken hata: \(error.localizedDescription)")
                           return
                       }
                       
                       if let url = data as? URL {
                           print("Paylaşılan URL: \(url.absoluteString)")
                           self.processSharedData(type: "URL", content: url.absoluteString)
                       } else {
                           print("URL'yi dönüştürme başarısız.")
                       }
                   }
               }
               
               // Metni işleme
               if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
                   attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { (data, error) in
                       if let error = error {
                           print("Metin yüklenirken hata: \(error.localizedDescription)")
                           return
                       }
                       
                       if let text = data as? String {
                           print("Paylaşılan metin: \(text)")
                           self.processSharedData(type: "Text", content: text)
                       } else {
                           print("Metni dönüştürme başarısız.")
                       }
                   }
               }
           }
       }
       
       private func processSharedData(type: String, content: String) {
           let sharedDefaults = UserDefaults(suiteName: "group.com.youtubeSummarizer")
           
           if type == "URL" {
               sharedDefaults?.set(content, forKey: "sharedURL")
           } else if type == "Text" {
               sharedDefaults?.set(content, forKey: "sharedText")
           }
           
           sharedDefaults?.synchronize()
       }
       
    
    
}
