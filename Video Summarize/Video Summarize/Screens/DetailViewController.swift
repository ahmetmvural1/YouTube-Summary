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
import StoreKit
import Lottie

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var data : SummarizerResponse?
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var animeView: UIView!
    
    @IBOutlet weak var shareButton: UIButton!{
        didSet {
            shareButton.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 18)!
            shareButton.setTitle(Text.shareSummary, for: .normal)
        }
    }
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
    
    @IBOutlet weak var detailLabel: UILabel! {
        didSet {
            detailLabel.font = UIFont(name: "SFProRounded-Regular", size: 16)!
        }
    }
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
    // MARK: - Properties
    private var animationView: LottieAnimationView?
    
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
        setAttributedTextForLabel(label: detailLabel, text: data?.summary ?? "")
        videoID = data?.videoId
        loadYouTubeVideo(videoID: videoID ?? "")
        
        if data?.message == "loading" {
            fetchSummary(videoUrl: data?.videoId ?? "", langCode: data?.langCode ?? "en")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAppReview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

            // Geri butonuna basıldığında ana sayfaya yönlendir
            if self.isMovingFromParent {
                navigationController?.popToRootViewController(animated: true)
            }
    }
    
    private func fetchSummary(videoUrl: String, langCode: String) {
        self.addLottieAnimation()
        let summarizerService = SummarizerService()
        summarizerService.fetchSummary(videoUrl: videoUrl, langCode: langCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.removeLottieAnimation()
                    ResponseManager.shared.updateResponse(for: response.videoId ?? "", with: response)
                    self.data = response
                    self.detailLabel.text = self.data?.summary
                    if response.message == "loading" {
                        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ProcessViewController") as? ProcessViewController
                        vc?.modalPresentationStyle = .overFullScreen
                        vc?.modalTransitionStyle = .crossDissolve
                        vc?.delegate = self
                        self.present(vc ?? UIViewController(), animated: false)
                    }
                case .failure(let error):
                    self.removeLottieAnimation()
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    
    private func addLottieAnimation() {
        // Lottie animasyonunu yükle
        loadingView.isHidden = false
        view.isUserInteractionEnabled = false
        animationView = LottieAnimationView(name: "aninme")
        
        guard let animationView = animationView else { return }
        
        // Animasyonun çerçevesini ayarla
        animationView.frame = animeView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop // Animasyonu döngüye al
        animationView.play() // Animasyonu başlat
        
        // AnimeView'e animasyonu ekle
        animeView.addSubview(animationView)
    }

    // Animasyonu kaldırma işlemi
    private func removeLottieAnimation() {
        animationView?.stop() // Animasyonu durdur
        animationView?.removeFromSuperview() // Animasyonu görünümden kaldır
        animationView = nil // Referansı sıfırla
        
        // Loading ve etkileşim kontrollerini geri yükle
        loadingView.isHidden = true
        view.isUserInteractionEnabled = true
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
        utterance.rate = 0.5 // Daha hızlı yapmak için bu değeri artırabilirsiniz (örneğin, 0.6 veya 0.7)
        
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
    @IBAction func shareButtonAction(_ sender: Any) {
        shareSummary()
    }
    
    @objc func shareSummary() {
        let summary = Text.summaryShareTitle
        let appName = Text.shareDesc
        let appLink = "https://ahmetmvural.com.tr/youtube-summarize-download/"
        let shareMessage = """
        \(summary)
        \(detailLabel.text ?? "")

        \(appName) \(appLink)
        """

        // Paylaşım ekranını aç
        let activityViewController = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Text.okButton, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setAttributedTextForLabel(label: UILabel, text: String) {
        // Regular ve Bold font tanımları
        let regularFont = UIFont(name: "SFProRounded-Regular", size: 16)!
        let boldFont = UIFont(name: "SFProRounded-Bold", size: 18)!
        
        // ** işaretlerini temizlemeden önce regex ile bold bölgeleri belirle
        let regexPattern = "\\*\\*(.*?)\\*\\*"
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) ?? []
        
        // ** işaretlerini metinden temizle
        let cleanText = text.replacingOccurrences(of: "\\*\\*", with: "", options: .regularExpression)
        
        // Tüm metni önce Regular font olarak ayarla
        let attributedString = NSMutableAttributedString(string: cleanText)
        attributedString.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: cleanText.utf16.count))
        
        // Bold bölgeleri işaretle ve stil uygula
        for match in matches.reversed() { // Ters sırayla işleyerek indeks kaymasını önlüyoruz
            if let range = Range(match.range(at: 1), in: text) {
                let boldText = text[range]
                let cleanRange = (cleanText as NSString).range(of: String(boldText))
                
                // Bold fontu uygula
                attributedString.addAttribute(.font, value: boldFont, range: cleanRange)
            }
        }
        
        // Temizlenmiş ve işlenmiş metni UILabel'e ata
        label.attributedText = attributedString
    }

    
    func removeBoldMarkers(from text: String) -> String {
        // ** işaretlerini temizle
        let cleanText = text.replacingOccurrences(of: "**", with: "", options: .literal, range: nil)
        return cleanText
    }




}
extension DetailViewController: ProcessViewControllerDelegate {
    func didDismiss() {
        self.navigationController?.popViewController(animated: false)
    }
}

