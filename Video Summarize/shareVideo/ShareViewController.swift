//
//  ShareViewController.swift
//  shareVideo
//
//  Created by Ahmet Muhammet VURAL on 3.12.2024.
//

import UIKit

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Paylaş butonunu oluştur
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Paylaş", for: .normal)
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func shareButtonTapped() {
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let attachments = extensionItem.attachments {
            for attachment in attachments {
                if attachment.hasItemConformingToTypeIdentifier("public.url") {
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                        if let shareURL = url as? URL {
                            print("Paylaşılan URL: \(shareURL)")
                            
                            // URL'yi App Group aracılığıyla kaydet
                            let sharedDefaults = UserDefaults(suiteName: "group.com.yourapp.identifier")
                            sharedDefaults?.set(shareURL.absoluteString, forKey: "sharedLink")
                            
                            // Ana uygulamayı aç
                            if let appURL = URL(string: "yourapp://") {
                                self.openURL(appURL)
                            }
                            
                            // Paylaşma işlemini bitir
                            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func openURL(_ url: URL) {
        var responder = self as UIResponder?
        while responder != nil {
            if let application = responder as? UIApplication {
                application.perform(#selector(UIApplication.openURL(_:)), with: url)
                return
            }
            responder = responder?.next
        }
    }
}
