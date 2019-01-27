//
//  ViewModelController.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import RxSwift

typealias ViewModelController<ViewModelType: IViewModel, ViewType: IView> = BaseViewModelController<ViewModelType, ViewType> & IViewModelViewController

class BaseViewModelController<ViewModelType: IViewModel, ViewType: IView>: Controller<ViewType> {

    typealias IViewModelType = ViewModelType

    // MARK: - Properties

    let disposeBag = DisposeBag()

    let viewModel: ViewModelType

    required init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }

    func bindToViewModel() {

    }
}

