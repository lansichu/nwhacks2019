//
//  AppRouter.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import Swinject
import SwiftKeychainWrapper

final class AppRouter {
    
    static let shared = AppRouter()

    // MARK: - Properties

    private var container: AppContainer {
        return AppContainer.main
    }
    private var coordinator: Coordinator?

    // MARK: - Views

    private(set) var window: AppWindow?

    // MARK: - Init

    private init() {
        container.registerManagers()
        container.registerViewModels()
        container.registerControllers()
    }

    // MARK: - Methods
    
    func start(with options: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        window = AppWindow(frame: UIScreen.main.bounds)
        if KeychainWrapper.standard.hasValue(forKey: "id") {
            window?.rootViewController = NavigationController(rootViewController: container.resolve(VoiceRegisterController.self)!)
        } else {
            window?.rootViewController = NavigationController(rootViewController: container.resolve(SignUpController.self)!)
        }
        window?.makeKeyAndVisible()
    }

    func showProgressHUD() {
        DispatchQueue.main.async {
            self.window?.isActivityIndicatorVisible = true
        }
    }

    func dismissProgressHUD() {
        DispatchQueue.main.async {
            self.window?.isActivityIndicatorVisible = false
        }
    }
    
    func navigate(to route: Route, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.handleCoordination(of: route, animated: animated, completion: completion)
        }
    }

    private func handleCoordination(of route: Route, animated: Bool, completion: (() -> Void)?) {
        assert(Thread.isMainThread)
        guard let appRoute = route as? AppRoute else { return }
        switch appRoute {
        case .dispatch:
            let vc = container.resolve(DispatchController.self)!
            window?.switchRootViewController(vc, animated: true)
        case .setup:
            let vc = container.resolve(VoiceRegisterController.self)!
            let nav = NavigationController(rootViewController: vc)
            window?.switchRootViewController(nav, animated: true)
        case .store:
            let vc = container.resolve(PasswordStorageController.self)!
            let nav = NavigationController(rootViewController: vc)
            window?.switchRootViewController(nav, animated: true)
        case .signUp:
            let vc = container.resolve(SignUpController.self)!
            let nav = NavigationController(rootViewController: vc)
            window?.switchRootViewController(nav, animated: true)
        }
    }
}
