//
//  AppContainer.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import Swinject

typealias AppContainer = Container

extension AppContainer {
    static var main = AppContainer()

    func registerManagers() {
        register(LogService.self) { _ in
            return LogService.shared
        }
    }

    func registerViewModels() {
        register(AppViewModel.self) { _ in
            return AppViewModel()
        }.inObjectScope(.container)

        register(PasswordStorageVM.self) { r in
            let appViewModel = r.resolve(AppViewModel.self)!
            return PasswordStorageVM(appViewModel: appViewModel)
        }

        register(VoiceRegisterVM.self) { r in
            let appViewModel = r.resolve(AppViewModel.self)!
            return VoiceRegisterVM(appViewModel: appViewModel)
        }

        register(SignUpViewModel.self) { r in
            let appViewModel = r.resolve(AppViewModel.self)!
            return SignUpViewModel(appViewModel: appViewModel)
        }
    }

    func registerControllers() {

        register(DispatchController.self) { _ in DispatchController() }

        register(PasswordStorageController.self) { r in
            let viewModel = r.resolve(PasswordStorageVM.self)!
            return PasswordStorageController(viewModel: viewModel)
        }

        register(VoiceRegisterController.self) { r in
            let viewModel = r.resolve(VoiceRegisterVM.self)!
            return VoiceRegisterController(viewModel: viewModel)
        }

        register(SignUpController.self) { r in
            let viewModel = r.resolve(SignUpViewModel.self)!
            return SignUpController(viewModel: viewModel)
        }
    }

}
