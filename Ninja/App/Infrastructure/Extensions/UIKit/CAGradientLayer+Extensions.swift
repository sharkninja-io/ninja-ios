//
//  CAGradientLayer+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 2/24/23.
//

import UIKit

extension CAGradientLayer {
    func animateColorChange(newColors: [CGColor], duration: CGFloat = 1) {
        let colorAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        colorAnimation.fromValue = self.colors
        colorAnimation.toValue = newColors
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        colorAnimation.duration = duration
        colorAnimation.isRemovedOnCompletion = true

        self.colors = newColors
        CATransaction.begin()
        self.add(colorAnimation, forKey: #keyPath(CAGradientLayer.colors))
        CATransaction.commit()
    }

}
