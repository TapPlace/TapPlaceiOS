//
//  SceneDelegate.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: SplashViewController())
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        var storageViewModel = StorageViewModel()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        var vc: UIViewController = SplashViewController()
        
        let window = UIWindow(windowScene: windowScene)
        if storageViewModel.existUser(uuid: Constants.userDeviceID) {
            print("회원정보 있음")
            
            guard let url = URLContexts.first?.url else { return }
            
            guard url.scheme == "tapplace", url.host == "store" else { return }
            let urlString = url.absoluteString
            guard urlString.contains("place_id") else { return }
            let components = URLComponents(string: urlString)
            let urlQueryItems = components?.queryItems ?? []
            var dictionaryData = [String: String]()
            urlQueryItems.forEach { dictionaryData[$0.name] = $0.value }
            guard let placeID = dictionaryData["place_id"] else { return }
            
            guard let vc = TabBarViewController() as? TabBarViewController else { return }
            vc.showStoreInfo(storeID: placeID)
        } else {
            print("회원정보 없음")
            vc = SplashViewController()
        }
        
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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


}

