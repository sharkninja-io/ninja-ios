//
//  CookSelectionViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 3/4/23.
//

import UIKit

class CookSelectionViewCell: CookControlsViewCell {
    
    static var itemWidth: CGFloat {
        get { 80 }
    }
    var itemList: [Any] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var toggleController: ToggleButtonGroupController = .init()
    
    var selectedIndex: Int = -1 {
        didSet {
            self.collectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
    }

    var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CarouselCollectionViewCompositionalLayout(itemWidth: itemWidth, itemHeight: itemWidth + 24))
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
            
        collectionView.collectionViewLayout = CarouselCollectionViewCompositionalLayout(
            itemWidth: ModeSelectionViewCell.itemWidth,
            itemHeight: ModeSelectionViewCell.itemWidth + 24,
            itemSpacingWidth: getItemSpacing()
        )
        
        collectionView.register(SelectionItemViewCell.self, forCellWithReuseIdentifier: SelectionItemViewCell.VIEW_ID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
    }
    
    override func setupConstraints() {
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: 104),
            collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
         ])
    }
    
    func getItemSpacing() -> CGFloat {
        let width = self.bounds.width - 32
        var fullItemCount = floor(width / ModeSelectionViewCell.itemWidth)
        var halfCount = floor(width / (ModeSelectionViewCell.itemWidth / 2))
        if halfCount.truncatingRemainder(dividingBy: 2) == 0 {
            halfCount -= 1
            fullItemCount -= 1
        }
        return (width - (halfCount * ModeSelectionViewCell.itemWidth / 2)) / fullItemCount
    }
    
    func setDataToCell(item: Any, cell: SelectionItemViewCell) {
    }
}

extension CookSelectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionItemViewCell.VIEW_ID, for: indexPath)
        let item = itemList[indexPath.row]
        let toggleCell = (cell as? SelectionItemViewCell)
        if let toggleCell = toggleCell {
            setDataToCell(item: item, cell: toggleCell)
            // TODO: // FIX!!!!
            if !toggleController.buttonList.contains(toggleCell.button) {
                toggleController.addButton(toggleCell.button)
            }
            if indexPath.row == selectedIndex {
                _ = toggleController.selectButton(toggleCell.button, canDeselect: false)
            }
            toggleCell.theme = theme
        }
        return cell
    }
}
