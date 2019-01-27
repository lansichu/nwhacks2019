//
//  CollectionController.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

class CollectionController<ViewModelType: IListViewModel>: ViewModelController<ViewModelType, CollectionView> {

    // MARK: - Properties

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    var collectionView: CollectionView {
        return rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionView = rootView
    }

    override func bindToViewModel() {
        super.bindToViewModel()
        adapter.dataSource = viewModel
        viewModel.bindToAdapter(adapter).disposed(by: disposeBag)
    }
}
