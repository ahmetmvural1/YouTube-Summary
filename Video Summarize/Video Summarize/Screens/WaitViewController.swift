//
//  WaitViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 28.11.2024.
//

import UIKit

class WaitViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var premiumButton: UIButton! {
        didSet {
            premiumButton.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 16)!
            premiumButton.layer.cornerRadius = 10
            premiumButton.layer.masksToBounds = true
            premiumButton.layer.borderWidth = 3
            premiumButton.layer.borderColor = UIColor.systemGray6.cgColor
        }
    }
    @IBOutlet weak var descLabel: UILabel!{
        didSet {
            descLabel.font = UIFont(name: "SFProRounded-Regular", size: 18)!
        }
    }
    @IBOutlet weak var subTitle: UILabel!{
        didSet {
            subTitle.font = UIFont(name: "SFProRounded-SemiBold", size: 23)!
        }
    }
    @IBOutlet weak var percentLabel: UILabel!{
        didSet {
            percentLabel.font = UIFont(name: "SFProRounded-SemiBold", size: 50)!
        }
    }
    @IBOutlet weak var titleLable: UILabel!{
        didSet {
            titleLable.font = UIFont(name: "SFProRounded-Bold", size: 34)!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 8
        progressView.subviews[1].clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePremiumButton()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func animatePremiumButton() {
        UIView.animate(withDuration: 0.6, // Animasyon süresi
                       delay: 0, // Gecikme
                       options: [.autoreverse, .repeat], // Tersine ve sürekli tekrar
                       animations: {
            // Butonu büyüt
            self.premiumButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            // Animasyon bittiğinde (isteğe bağlı) butonu eski haline getir
            self.premiumButton.transform = .identity
        }
    }
    
}
