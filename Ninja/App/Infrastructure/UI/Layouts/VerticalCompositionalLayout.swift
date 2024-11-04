//
//  VerticalCompositionalLayout.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/17/22.
//

import UIKit

class VerticalCompositionalLayout: UICollectionViewCompositionalLayout {
    
    init() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 1, // TODO: //
            bottom: 0, trailing: 1 // TODO: //
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )

        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
 
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 0,
                                            leading: 0,
                                            bottom: 0,
                                            trailing: 0)
        // layoutSection.orthogonalScrollingBehavior = .none
        
        super.init(section: layoutSection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
