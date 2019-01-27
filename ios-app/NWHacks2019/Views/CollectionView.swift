//
//  CollectionView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView, IView {

    var flowLayout: UICollectionViewFlowLayout! {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }

    // MARK: - Init

    required convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.init(frame: frame, collectionViewLayout: layout)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewDidLoad()
    }

    // MARK: - View Life Cycle

    func viewDidLoad() {
        subscribeToThemeChanges()
        alwaysBounceVertical = true
    }

    // MARK: - Theme Updates

    func themeDidChange(_ theme: Theme) {
        backgroundColor = .white
    }
}
