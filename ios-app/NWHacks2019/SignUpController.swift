//
//  EditProfileController.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

final class SignUpController: ViewModelController<SignUpViewModel, SignUpView> {

    private lazy var saveItem = UIBarButtonItem(title: .localize(.save), style: .plain, target: self, action: #selector(didTapSave))

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = saveItem

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Demo Login", style: .plain, target: self, action: #selector(demoLogin))
    }

    override func bindToViewModel() {
        super.bindToViewModel()
        viewModel.isSaving.map { !$0 }.bind(to: saveItem.rx.isEnabled).disposed(by: disposeBag)
    }

    @objc
    private func didTapSave() {
        viewModel.saveChanges(fname: rootView.firstNameRow.textField.text, lname: rootView.lastNameRow.textField.text, phone: rootView.phoneRow.textField.text)
    }

    @objc
    private func demoLogin() {
        KeychainWrapper.standard.set("7af3dadb-b145-410a-b3d5-f3b88de9bbdf", forKey: "id")
        AppRouter.shared.navigate(to: AppRoute.setup)
    }
}
