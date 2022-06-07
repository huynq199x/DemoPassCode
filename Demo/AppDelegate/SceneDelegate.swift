//
//  SceneDelegate.swift
//  Demo
//
//  Created by Nguyen Quang Huy on 22/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CheckPassCode") as! PassCodeViewController
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CheckPassCode") as! PassCodeViewController
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
    }
}

