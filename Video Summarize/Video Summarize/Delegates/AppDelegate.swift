//
//  AppDelegate.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 25.11.2024.
//

import UIKit
import Firebase
import RevenueCat

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "SFProRounded-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.text // Standart başlık metni rengi
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes

        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont(name: "SFProRounded-Bold", size: 34)!, // Büyük başlık font boyutu
            NSAttributedString.Key.foregroundColor: UIColor.text // Büyük başlık metni rengi
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleAttributes

        UINavigationBar.appearance().tintColor = .primary // Geri düğmesi veya diğer öğeler için renk
        UINavigationBar.appearance().barTintColor = .clear // Arka plan rengi siyah
        FirebaseApp.configure()
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_PAGjmolPKICcHKidLuaISvGvEOY")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

