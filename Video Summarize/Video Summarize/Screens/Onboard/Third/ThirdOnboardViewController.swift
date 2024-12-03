//
//  ThirdOnboardViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 29.11.2024.
//

import UIKit

class ThirdOnboardViewController: UIViewController {

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle(Text.thirdOnboardButton, for: .normal)
            button.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 20)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.primary.cgColor
        }
    }
    
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.text = Text.thirdOnboardDesc
            descLabel.font = UIFont(name: "SFProRounded-Medium", size: 17)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text =  Text.thirdOnboardTitle
            titleLabel.font = UIFont(name: "SFProRounded-Bold", size: 25)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    


    @IBAction func buttonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            let navigationController = UINavigationController(rootViewController: mainVC)
            navigationController.navigationBar.prefersLargeTitles = true
            mainVC.navigationItem.title = "YouTube Summarize"
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false, completion: nil)
        }

    }
}
