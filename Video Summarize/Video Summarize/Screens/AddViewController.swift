//
//  AddViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 26.11.2024.
//

import UIKit
import Lottie

class AddViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var animeView: UIView!
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            createButton.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 18)!
            createButton.layer.cornerRadius = 10
            createButton.layer.masksToBounds = true
            createButton.layer.borderWidth = 3
            createButton.layer.borderColor = UIColor.systemGray6.cgColor
            createButton.isEnabled = false
            createButton.alpha = 0.5
        }
    }
    @IBOutlet weak var languageTitle: UILabel! {
        didSet {
            languageTitle.font = UIFont(name: "SFProRounded-SemiBold", size: 18)!
        }
    }
    @IBOutlet weak var russiaButton: UIButton!
    @IBOutlet weak var germanButton: UIButton!
    @IBOutlet weak var spainButton: UIButton!
    @IBOutlet weak var portugalButton: UIButton!
    @IBOutlet weak var franchButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var japanButton: UIButton!
    @IBOutlet weak var italianoButton: UIButton!
    @IBOutlet weak var turkishButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField! {
        didSet {
            linkTextField.font = UIFont(name: "SFProRounded-Regular", size: 16)!
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            // "Tamam" butonu ekleme
            let doneButton = UIBarButtonItem(title: Text.okButton, style: .done, target: self, action: #selector(doneButtonTapped))
            doneButton.tintColor = .primary
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            // Toolbar'a butonları ekle
            toolbar.items = [flexibleSpace, doneButton]
            
            // Toolbar'ı textfield'a ekle
            linkTextField.inputAccessoryView = toolbar
        }
    }
    @IBOutlet weak var pasteButton: UIButton! {
        didSet {
            pasteButton.titleLabel?.font = UIFont(name: "SFProRounded-SemiBold", size: 16)!
        }
    }
    
    // MARK: - Properties
    private var animationView: LottieAnimationView?
    
    var deeplink: String?

    private var selectedLanguage: String = "tr" // Varsayılan dil Türkçe
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultLanguageBasedOnDevice() // Cihaz diline göre varsayılan dili ayarla
        updateButtonStyles(selectedButton: getButtonForLanguage(selectedLanguage)) // Varsayılan seçili buton
        linkTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
        
        if deeplink != nil {
            linkTextField.text = deeplink
            createButton.isEnabled = true
            createButton.alpha = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        linkTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Eğer textField boşsa createButton'u devre dışı bırak
        if let text = textField.text, text.isEmpty {
            createButton.isEnabled = false
            createButton.alpha = 0.5 // Devre dışı görünüm
        } else {
            createButton.isEnabled = true
            createButton.alpha = 1.0 // Aktif görünüm
        }
    }
    
    private func setDefaultLanguageBasedOnDevice() {
        // Cihazın dilini algıla
        let deviceLanguage = Locale.current.languageCode ?? "en" // Varsayılan dil İngilizce

        switch deviceLanguage {
        case "ru":
            selectedLanguage = "ru"
        case "de":
            selectedLanguage = "de"
        case "es":
            selectedLanguage = "es"
        case "pt":
            selectedLanguage = "pt"
        case "fr":
            selectedLanguage = "fr"
        case "en":
            selectedLanguage = "en"
        case "ja":
            selectedLanguage = "ja"
        case "it":
            selectedLanguage = "it"
        case "tr":
            selectedLanguage = "tr"
        default:
            selectedLanguage = "en" // Desteklenmeyen diller için İngilizce varsayılıyor
        }
    }
    
    private func getButtonForLanguage(_ language: String) -> UIButton {
        switch language {
        case "ru":
            return russiaButton
        case "de":
            return germanButton
        case "es":
            return spainButton
        case "pt":
            return portugalButton
        case "fr":
            return franchButton
        case "en":
            return englishButton
        case "ja":
            return japanButton
        case "it":
            return italianoButton
        case "tr":
            return turkishButton
        default:
            return englishButton // Varsayılan olarak İngilizce düğmesi seçili
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
    
    @objc private func doneButtonTapped() {
        linkTextField.resignFirstResponder() 
    }
    
    func updateButtonStyles(selectedButton: UIButton) {
        // Tüm butonları bir dizide toplayın
        let buttons = [
            russiaButton,
            germanButton,
            spainButton,
            portugalButton,
            franchButton,
            englishButton,
            japanButton,
            italianoButton,
            turkishButton
        ]
        
        for button in buttons {
            if button != selectedButton {
                button?.layer.cornerRadius = 8
                button?.layer.borderWidth = 2
                button?.layer.borderColor = UIColor.systemGray6.cgColor
                button?.backgroundColor = .clear
                button?.setTitleColor(.text, for: .normal)
            } else {
                button?.layer.cornerRadius = 8
                button?.layer.borderWidth = 2
                button?.layer.borderColor = UIColor.systemGray6.cgColor
                button?.backgroundColor = UIColor.primary
                button?.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        updateButtonStyles(selectedButton: sender)
        
        // Dil seçimini güncelle
        switch sender {
        case russiaButton:
            selectedLanguage = "ru"
        case germanButton:
            selectedLanguage = "de"
        case spainButton:
            selectedLanguage = "es"
        case portugalButton:
            selectedLanguage = "pt"
        case franchButton:
            selectedLanguage = "fr"
        case englishButton:
            selectedLanguage = "en"
        case japanButton:
            selectedLanguage = "ja"
        case italianoButton:
            selectedLanguage = "it"
        case turkishButton:
            selectedLanguage = "tr"
        default:
            break
        }
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        guard let videoUrl = linkTextField.text, !videoUrl.isEmpty else {
            showAlert(title: "Error", message: "Please enter a YouTube URL.")
            return
        }
        
        fetchSummary(videoUrl: videoUrl, langCode: selectedLanguage)
    }
    
    @IBAction func pasteButton(_ sender: Any) {
        if let pastedText = UIPasteboard.general.string {
            linkTextField.text = pastedText
            if linkTextField.text?.count ?? 0 > 0 {
                createButton.isEnabled = true
                createButton.alpha = 1.0 // Aktif görünüm
            }
        }
        
    }
    
    // MARK: - Network Request
    private func fetchSummary(videoUrl: String, langCode: String) {
        self.addLottieAnimation()
        let summarizerService = SummarizerService()
        summarizerService.fetchSummary(videoUrl: videoUrl, langCode: langCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.removeLottieAnimation()
                    ResponseManager.shared.saveResponse(response)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                        detailViewController.data = response
                        self.navigationController?.pushViewController(detailViewController, animated: true)
                    }
                case .failure(let error):
                    self.removeLottieAnimation()
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Text.okButton, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
