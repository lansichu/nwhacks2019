//
//  CollectionReusableView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class CollectionReusableView<ViewType: IReusableView>: UICollectionReusableView, IReuseIdentifiable, IWrapperView {

    class var reuseIdentifier: String {
        return String(describing: self)
    }

    let wrappedView: ViewType

    override init(frame: CGRect) {
        wrappedView = ViewType(frame: frame)
        super.init(frame: frame)
        cellDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        wrappedView = ViewType()
        super.init(coder: aDecoder)
        cellDidLoad()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        wrappedView.prepareForReuse()
    }

    func cellDidLoad() {
        addSubview(wrappedView)
        wrappedView.fillSuperview()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

