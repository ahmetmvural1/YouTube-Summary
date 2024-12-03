//
//  DetailViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 28.11.2024.
//

import UIKit
import WebKit
import SkeletonView
import AVFoundation

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var data : SummarizerResponse?

    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = UIFont(name: "SFProRounded-Bold", size: 22)!
        }
    }
    @IBOutlet weak var timeTitle: UILabel! {
        didSet {
            timeTitle.font = UIFont(name: "SFProRounded-SemiBold", size: 16)!
        }
    }
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.layer.cornerRadius = 8
            webView.layer.masksToBounds = true
            webView.isSkeletonable = true // Skeleton özelliğini etkinleştir
        }
    }
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var videoTitle: UILabel! {
        didSet {
            videoTitle.font = UIFont(name: "SFProRounded-SemiBold", size: 16)!
            videoTitle.isSkeletonable = true // Skeleton özelliğini etkinleştir
        }
    }
    
    @IBOutlet weak var frameView: UIView! {
        didSet {
            frameView.isSkeletonable = true // Skeleton özelliğini etkinleştir
        }
    }
    
    
    var videoID: String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Skeleton animasyonlu efekti başlat
        frameView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .lightGray),
                                               animation: nil,
                                               transition: .crossDissolve(0.25))
        videoTitle.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .lightGray),
                                                animation: nil,
                                                transition: .crossDissolve(0.25))
        
        webView.navigationDelegate = self
        let minutes: Int = (data?.duration ?? 0) / 60
        timeLabel.text = "\(minutes) \(Text.min)"
        videoTitle.text = data?.title
        detailLabel.text = data?.summary
        videoID = data?.videoId
        loadYouTubeVideo(videoID: videoID ?? "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

            // Geri butonuna basıldığında ana sayfaya yönlendir
            if self.isMovingFromParent {
                navigationController?.popToRootViewController(animated: true)
            }
    }
    
    private func loadYouTubeVideo(videoID: String) {
        // iFrame HTML kodu
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    background-color: black; /* Gereksiz kenar boşlukları görünmesin */
                }
                iframe {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    border: none;
                }
            </style>
        </head>
        <body>
            <iframe src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </body>
        </html>
        """
        
        // HTML kodunu webView içinde yükle
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Video Yüklendi")
        
        // Skeleton animasyonunu durdur
        frameView.hideSkeleton(transition: .crossDissolve(0.25))
        videoTitle.hideSkeleton(transition: .crossDissolve(0.25))
        videoTitle.text = data?.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Yükleme Hatası: \(error.localizedDescription)")
        
        // Skeleton animasyonunu hata durumunda durdur
        frameView.hideSkeleton(transition: .crossDissolve(0.25))
        videoTitle.hideSkeleton(transition: .crossDissolve(0.25))
        videoTitle.text = data?.title
    }
    
    @IBAction func speachButton(_ sender: Any) {
        let text = detailLabel.text ?? ""
        let userLanguage = Locale.current.languageCode ?? "en"
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: userLanguage)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        
        speechSynthesizer.speak(utterance)
    }
    
    @IBAction func openVideo(_ sender: Any) {
        let appURL = URL(string: "youtube://\(videoID ?? "")")! // YouTube uygulaması için URL
        let webURL = URL(string: "https://www.youtube.com/watch?v=\(videoID ?? "")")! // Tarayıcı için URL
        
        if UIApplication.shared.canOpenURL(appURL) {
            // Eğer YouTube uygulaması yüklüyse aç
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            // Eğer YouTube uygulaması yoksa tarayıcıda aç
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}
