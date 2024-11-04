//
//  UICollectionViewCell+Extensions.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/14/22.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        self.register(type.self, forCellWithReuseIdentifier: T.VIEW_ID)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, type: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.VIEW_ID, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(T.VIEW_ID) matching type \(type.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
}
