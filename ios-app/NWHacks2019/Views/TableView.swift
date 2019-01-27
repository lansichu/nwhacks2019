//
//  TableView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class TableView: UITableView, IView {

    // MARK: - Init

    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewDidLoad()
    }

    // MARK: - View Life Cycle

    func viewDidLoad() {
        subscribeToThemeChanges()
        separatorStyle = .none
    }

    // MARK: - Theme Updates

    func themeDidChange(_ theme: Theme) {
        backgroundColor = .white
    }
}
