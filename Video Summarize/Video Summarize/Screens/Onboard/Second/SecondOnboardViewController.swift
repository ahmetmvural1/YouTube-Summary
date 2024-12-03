//
//  SecondOnboardViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 29.11.2024.
//

import UIKit

class SecondOnboardViewController: UIViewController {

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle(Text.secondOnboardButton, for: .normal)
            button.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 20)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.primary.cgColor
        }
    }
    
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.text = Text.secondOnboardDesc
            descLabel.font = UIFont(name: "SFProRounded-Medium", size: 17)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Text.secondOnboardTitle
            titleLabel.font = UIFont(name: "SFProRounded-Bold", size: 25)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


    @IBAction func buttonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ThirdOnboard", bundle: Bundle.main)
        if let secondOnboardVC = storyboard.instantiateViewController(withIdentifier: "ThirdOnboardViewController") as? ThirdOnboardViewController {
            secondOnboardVC.modalPresentationStyle = .fullScreen
            
            // Sağdan sola geçiş animasyonu eklemek için özel bir geçiş stili tanımlayın
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromRight  // Sağdan sola geçiş için `.fromRight` kullanıyoruz
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            // Pencereye geçişi uygulayın
            view.window?.layer.add(transition, forKey: kCATransition)
            
            // İkinci onboarding ekranını sunun
            present(secondOnboardVC, animated: false, completion: nil)
        }
    }
    
}
