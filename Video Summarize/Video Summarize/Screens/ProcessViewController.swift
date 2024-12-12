//
//  ProcessViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 10.12.2024.
//

import UIKit

protocol ProcessViewControllerDelegate: AnyObject {
    func didDismiss()
}

class ProcessViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton! {
        didSet {
            updateButton.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 18)!
            updateButton.setTitle(Text.okButton, for: .normal)
        }
    }
    @IBOutlet weak var descLabel: UILabel!{
        didSet {
            descLabel.font = UIFont(name: "SFProRounded-Regular", size: 18)!
            descLabel.text = Text.videoProcessDesc
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.font = UIFont(name: "SFProRounded-Bold", size: 22)!
            titleLabel.text = Text.videoProcessTitle
        }
    }
    
    weak var delegate: ProcessViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.didDismiss()
        }
    }
}
