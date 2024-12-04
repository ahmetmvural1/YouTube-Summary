//
//  SceneDelegate.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 25.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.youtubeSummarizer")
        var deepLink: String?

        // Paylaşılan URL'yi kontrol et
        if let sharedURL = sharedDefaults?.string(forKey: "sharedURL") {
            deepLink = sharedURL
            sharedDefaults?.removeObject(forKey: "sharedURL")
            sharedDefaults?.synchronize()
        }

        // Paylaşılan Metni kontrol et
        if let sharedText = sharedDefaults?.string(forKey: "sharedText") {
            deepLink = sharedText
            sharedDefaults?.removeObject(forKey: "sharedText")
            sharedDefaults?.synchronize()
        }

        if let deepLink = deepLink {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let addViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController {
                addViewController.deeplink = deepLink
                
                // Root ViewController'dan NavigationController'ı alın
                if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
                    
                    // Tüm ekranları temizle
                    navigationController.popToRootViewController(animated: false)
                    
                    // `AddViewController`'ı yönlendirme
                    navigationController.pushViewController(addViewController, animated: true)
                } else {
                    print("NavigationController bulunamadı.")
                }
            } else {
                print("AddViewController yüklenemedi.")
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, url.scheme == "youtubeSummarize" {
            print("Uygulama bu URL ile açıldı: \(url)")
            // URL'yi işlemek için buraya kod ekleyebilirsiniz
        }
    }
}

