//
//  SceneDelegate.swift
//  BN-2021
//
//  Created by Patryk Strzemiecki on 05/11/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else {
            fatalError()
        }
        startInitialFlow(from: scene)
    }
}

private extension SceneDelegate {
    func startInitialFlow(from scene: UIWindowScene) {
        let navigationController = UINavigationController()
        let coordinator = DefaultAppCoordinator(
            navigationController: navigationController
        )
        coordinator.start()
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

protocol AppCoordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    func contacts(permissionAllowed: Bool)
}

final class DefaultAppCoordinator: AppCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AppCoordinator {
    func start() {
        let vc = FirstViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func contacts(permissionAllowed: Bool) {
        let vc = UIViewController()
        vc.title = permissionAllowed
            ? "Contacts Permissions Allowed, yay!"
            : "Disallowed :("
        vc.view.backgroundColor = permissionAllowed ? .green : .red
        navigationController.pushViewController(vc, animated: true)
    }
}
