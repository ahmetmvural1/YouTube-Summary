//
//  FirstOnboardViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 29.11.2024.
//

import UIKit

class FirstOnboardViewController: UIViewController {

    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle(Text.firstOnboardButton, for: .normal)
            button.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 20)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.primary.cgColor
        }
    }
    
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.text = Text.firstOnboardDesc
            descLabel.font = UIFont(name: "SFProRounded-Medium", size: 17)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Text.firstOnboardTitle
            titleLabel.font = UIFont(name: "SFProRounded-Bold", size: 25)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    


    @IBAction func buttonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SecondOnboard", bundle: Bundle.main)
        if let secondOnboardVC = storyboard.instantiateViewController(withIdentifier: "SecondOnboardViewController") as? SecondOnboardViewController {
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
