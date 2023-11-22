//
//  AppDelegate.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootView()
        return true
    }

    private func setRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeViewModule.build(with: .init())
        window?.makeKeyAndVisible()
    }
}

