//
//  EditProfileViewModel.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper
import AlertHUDKit

final class SignUpViewModel: ViewModel {

    let isSaving = BehaviorSubject<Bool>(value: false)
    let disposeBag = DisposeBag()

    func saveChanges(fname: String?, lname: String?, phone: String?) {
        isSaving.onNext(true)
        AppRouter.shared.showProgressHUD()
        NetworkService.shared
            .request(.createUser, decodeAs: User.self)
            .flatMap { user in
                return NetworkService.shared.request(.updateUser(userId: user.id, fname: fname ?? "F_NAME", lname: lname ?? "L_NAME", phone: phone ?? "6043556292"), decodeAs: User.self)
            }.subscribe(onSuccess: { user in
            AppRouter.shared.dismissProgressHUD()
            KeychainWrapper.standard.set(user.id, forKey: "id")
            self.isSaving.onNext(false)
            AppRouter.shared.navigate(to: AppRoute.setup)
        }) { err in
            self.isSaving.onNext(false)
            AppRouter.shared.dismissProgressHUD()
            Ping(text: err.localizedDescription, style: .danger).show()
        }.disposed(by: disposeBag)
    }
}
