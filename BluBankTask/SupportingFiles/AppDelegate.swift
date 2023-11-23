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
        let networkManager: NetworkManagerProtocol = URLSessionNetworkManager()
        let databaseManager: DatabaseManagerProtocol = Database()
        let homeDAO: HomeDAOProtocol = HomeDAO(databaseManager: databaseManager)
        let repository: HomeRepositoryProtocol = HomeRepository(networkManager: networkManager, homeDAO: homeDAO)
        window?.rootViewController = HomeViewModule.build(with: .init(repository: repository))
        window?.makeKeyAndVisible()
    }
}

