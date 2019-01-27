//
//  PasswordStorageVM.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import RxSwift

struct PasswordStore: Model {
    typealias ID = String

    var id: String
    var name: String
    var url: String
    var password: String

    init(name: String, url: String) {
        self.id = name
        self.name = name
        self.url = url
        self.password = String.randomOfLength(16)
    }

    static var defaults: [PasswordStore] {
        return [
            PasswordStore(name: "Facebook", url: "https://facebook.com"),
            PasswordStore(name: "Google", url: "https://google.com"),
            PasswordStore(name: "Twitter", url: "https://twitter.com"),
            PasswordStore(name: "TD", url: "https://td.com"),
            PasswordStore(name: "RBC", url: "https://www.rbcroyalbank.com"),
            PasswordStore(name: "Microsoft", url: "https://microsoft.com"),
            PasswordStore(name: "GitHub", url: "https://github.com"),
            PasswordStore(name: "Starbucks Rewards", url: "https://starbucks.com"),
            PasswordStore(name: "LinkedIn", url: "https://linkedin.com"),
            PasswordStore(name: "Reddit", url: "https://reddit.com")
        ]
    }
}

final class PasswordStorageVM: ViewModel {
    private let disposeBag = DisposeBag()
    private let stores = BehaviorSubject<[PasswordStore]>(value: [])

    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        stores.onNext(PasswordStore.defaults)
    }

    func bindTo(view: PasswordStorageView) {
        view.dataSource = self
        view.delegate = self
        stores.subscribe { [weak view] event in
            view?.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension PasswordStorageVM: UICollectionViewDataSource {
    private func value(for indexPath: IndexPath) -> PasswordStore {
        return stores.value![indexPath.section]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return stores.value?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(PasswordStoreCell.self, for: indexPath)
        cell.configure(for: value(for: indexPath))
        return cell
    }
}

extension PasswordStorageVM: UICollectionViewDelegateFlowLayout {
    var inset: UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 12, bottom: 3, right: 12)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(
            width: collectionView.bounds.width - inset.horizontal,
            height: 50 - inset.vertical
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return inset
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = .identity
        }
    }
}
