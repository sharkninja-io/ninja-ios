//
//  CarouselCollectionViewCompositionalLayout.swift
//  Ninja
//
//  Created by Martin Burch on 8/22/22.
//

import UIKit

class CarouselCollectionViewCompositionalLayout: UICollectionViewCompositionalLayout {
    
    init(itemWidth: CGFloat, itemHeight: CGFloat, itemSpacingWidth: CGFloat = 0, scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous) {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, // TODO: //
            bottom: 0, trailing: 0 // TODO: //
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth + itemSpacingWidth),
            heightDimension: .absolute(itemHeight)
        )

        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: layoutItem,
            count: 1
        )
 
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 0,
                                            leading: 0,
                                            bottom: 0,
                                            trailing: 0)
        layoutSection.orthogonalScrollingBehavior = scrollingBehavior
        
        super.init(section: layoutSection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
