//
//  UpdatedViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 4.12.2024.
//

import UIKit

class UpdatedViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton! {
        didSet {
            updateButton.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 18)!
            updateButton.setTitle(Text.forceUpdateOkButton, for: .normal)
        }
    }
    @IBOutlet weak var descLabel: UILabel!{
        didSet {
            descLabel.font = UIFont(name: "SFProRounded-Regular", size: 18)!
            descLabel.text = Text.forceUpdateMessage
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.font = UIFont(name: "SFProRounded-Bold", size: 22)!
            titleLabel.text = Text.forceUpdateTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/app/\(AppConfig.id)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
