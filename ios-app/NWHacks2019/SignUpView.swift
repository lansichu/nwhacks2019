//
//  EditProfileView.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpView: ListView {

    let firstNameRow = TextFieldCell()
    let lastNameRow = TextFieldCell()
    let phoneRow = TextFieldCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = UIColor.groupTableViewBackground
        loadRows()
    }

    private func loadRows() {

        firstNameRow.label.text = "First Name:"
        firstNameRow.textField.placeholder = "First Name"

        lastNameRow.label.text = "Last Name:"
        lastNameRow.textField.placeholder = "Last Name"

        let emailRow = TextFieldCell()
        emailRow.label.text = "Email (Optional):"
        emailRow.textField.placeholder = "Email"
        emailRow.textField.keyboardType = .emailAddress

        phoneRow.label.text = "Phone:"
        phoneRow.textField.placeholder = "Phone"
        phoneRow.textField.keyboardType = .phonePad

        appendRows(firstNameRow, lastNameRow, emailRow, phoneRow)
    }
}
