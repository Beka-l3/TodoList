//
//  AppDelegate.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 01.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appCoordinator = AppCoordinator()
        
        let navigationController = UINavigationController(rootViewController: appCoordinator.getMainPage())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }


}
