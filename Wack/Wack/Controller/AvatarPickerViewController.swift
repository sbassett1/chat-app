//
//  AvatarPickerViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var avatarCollectionView: UICollectionView!
    @IBOutlet private var darkLightSegmentControl: UISegmentedControl!

    // MARK: Variables

    var avatarType = AvatarType.dark

    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatarCollectionView.delegate = self
        self.avatarCollectionView.dataSource = self
    }

    // MARK: Actions

    @IBAction private func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func darkLightTapped(_ sender: Any) {
        self.avatarType = self.darkLightSegmentControl.selectedSegmentIndex == 0 ? .dark : .light
        self.avatarCollectionView.reloadData()
    }
}

extension AvatarPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.avatarCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifiers.avatarCell, for: indexPath) as? AvatarCell else { return AvatarCell() }
        cell.configureCell(index: indexPath.item, type: self.avatarType)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = UIScreen.main.bounds.width > 320 ? 4 : 3
        let spaceBetweenCells: CGFloat = 10
        let screenInset: CGFloat = 40
        let widthMinusInsets: CGFloat = self.avatarCollectionView.bounds.width - screenInset
        let totalPaddingBetweenCells: CGFloat = (numberOfColumns - 1) * spaceBetweenCells
        let cellDimension = (widthMinusInsets - totalPaddingBetweenCells) / numberOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = self.avatarType == .dark ? "dark" : "light"
        UserDataService.shared.setAvatarName(avatarName: "\(name)\(indexPath.item)")
        self.dismiss(animated: true, completion: nil)
    }
}
