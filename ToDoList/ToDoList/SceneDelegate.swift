//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setup(scene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

}

// MARK: - Setup & Appearance

private extension SceneDelegate {
    
    func setup(_ scene: UIScene) {
        setupAppearance()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.overrideUserInterfaceStyle = .dark
        window?.makeKeyAndVisible()
        window?.rootViewController = TaskListModuleBuilder.build()
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().layoutMargins.left = 20
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor(hex: "#FED702")
        UIButton.appearance().tintColor = UIColor(hex: "#FED702")
        UITableView.appearance().separatorColor = UIColor(hex: "#4D555E")
        if let contextMenuViewClass = NSClassFromString("_UIContextMenuView") as? UIView.Type {
            contextMenuViewClass.appearance().overrideUserInterfaceStyle = .light
        }
    }
    
}
