//
//  ExploreFoodSelectorFilterTableViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/15/23.
//

import UIKit


class FoodCategoryItem: Equatable {

    var title: String
    var icon: UIImage
    
    init(title: String, icon: UIImage) {
        self.title = title
        self.icon = icon
    }
    
    static func == (lhs: FoodCategoryItem, rhs: FoodCategoryItem) -> Bool {
        lhs.title == rhs.title
    }
    
}
class ExploreFoodSelectorFilterTableViewCell: ModeSelectionViewCell {
    
    var foodOptionList: [FoodCategoryItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var multiToggleController: MultiToggleButtonGroupController = {
        let controller = MultiToggleButtonGroupController()
        controller.identityComparer = { first, second in first as? String == second as? String }
        return controller
    }()
    
    internal var titleLabel: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.text = "Food Selector".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var subtitleLabel: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.text = "Select as much as you want".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var titlesVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8.0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    override func setupViews() {
        super.setupViews()
        collectionView.collectionViewLayout = CarouselCollectionViewCompositionalLayout(
            itemWidth: ModeSelectionViewCell.itemWidth + 2,
            itemHeight: ModeSelectionViewCell.itemWidth + 56,
            itemSpacingWidth: getItemSpacing()
        )
    }
        
    override func refreshStyling() {
        super.refreshStyling()
        titleLabel.setStyle(.pageIndicatorTitleLabel)
        subtitleLabel.setStyle(.settingsCellDetail)
    }

    override func setupConstraints() {
        titlesVStack.addArrangedSubview(titleLabel)
        titlesVStack.addArrangedSubview(subtitleLabel)
        contentView.addSubview(titlesVStack)
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            titlesVStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            titlesVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),

            collectionView.topAnchor.constraint(equalTo: titlesVStack.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            
            
         ])
    }
}

extension ExploreFoodSelectorFilterTableViewCell {
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
