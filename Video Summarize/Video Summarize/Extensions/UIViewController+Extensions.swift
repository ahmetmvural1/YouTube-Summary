//
//  UIViewController+Extensions.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 25.11.2024.
//

import UIKit

extension UIViewController {
    func push(_ viewControllerIdentifier: StoryboardIdentifier, from storyboardName: String = "Main", animated: Bool = true)  {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier.rawValue)
        navigationController?.pushViewController(viewController, animated: animated)
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
enum StoryboardIdentifier: String {
    case addChatViewController = "AddChatViewController"
}
