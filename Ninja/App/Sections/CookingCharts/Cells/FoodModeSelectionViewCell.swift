//
//  FoodCategoryModeSelectionViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 2/17/23.
//

import Foundation
import UIKit

class FoodModeSelectionViewCell: ModeSelectionViewCell {
    
    var multiToggleController: MultiToggleButtonGroupController = {
        let controller = MultiToggleButtonGroupController()
        controller.identityComparer = { first, second in first as? String == second as? String }
        return controller
    }()
    
    var foodOptionList: [FoodCategoryItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func setupViews() {
        super.setupViews()
        collectionView.collectionViewLayout = CarouselCollectionViewCompositionalLayout(
            itemWidth: ModeSelectionViewCell.itemWidth + 2,
            itemHeight: ModeSelectionViewCell.itemWidth + 56,
            itemSpacingWidth: getItemSpacing()
        )
    }
    
    override func setupConstraints() {
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: 124),
            collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
         ])
    }
}

extension FoodModeSelectionViewCell {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodOptionList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionItemViewCell.VIEW_ID, for: indexPath)
        let item = foodOptionList[indexPath.row]
        if let toggleCell = (cell as? SelectionItemViewCell) {
            toggleCell.button.label.numberOfLines = 0
            toggleCell.setData(title: item.title, icon: item.icon, identifier: item.title)
            if !multiToggleController.buttonList.contains(toggleCell.button) {
                multiToggleController.addButton(toggleCell.button)
            }
            if multiToggleController.isSelected(toggleCell.button){
                _ = multiToggleController.selectButton(toggleCell.button, canDeselect: false)
            } else {
                multiToggleController.deselectButton(toggleCell.button)
            }
        }
        return cell
    }
}
