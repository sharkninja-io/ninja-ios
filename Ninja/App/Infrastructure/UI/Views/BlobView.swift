//
//  GreenBlob.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/21/22.
//

import UIKit

@IBDesignable
class BlobView: UIView, CAAnimationDelegate {
    
    let squareRt2 = 1.414214
    var radius: CGFloat = 1
    var fillColor: UIColor = ColorThemeManager.shared.theme.primaryAccentColor
    var animationCompletion: (() -> Void)? = nil
    var animationDuration: TimeInterval = 0
    
    private var doFadeOut = true
    
    var blob: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 0
        layer.fillColor = UIColor.clear.cgColor
        layer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 1, height: 1)).cgPath
        layer.isHidden = true
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    func initializeBlob(frame: CGRect) {
        radius = max(frame.height, frame.width) * squareRt2 / 4
        let baseCircle = UIBezierPath(ovalIn:
                CGRect(x: (frame.width - radius) / 2,
                       y: (frame.height - radius) / 2,
                       width: radius,
                       height: radius))
        blob.fillColor = fillColor.cgColor
        blob.path = baseCircle.cgPath
    }
    
    func animateWithFade(duration: TimeInterval, completion: (() -> Void)?) {
        animationCompletion = completion
        animationDuration = duration
        doFadeOut = true
        animateIn(duration: duration * 0.5)
    }
    
    func animate(duration: TimeInterval, completion: (() -> Void)?) {
        animationCompletion = completion
        animationDuration = duration
        doFadeOut = false
        animateIn(duration: duration * 0.5)
    }
    
    private func animateIn(duration: TimeInterval) {
        let positionAnimation = CASpringAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.fromValue = CGPoint(x: frame.width/2, y: frame.height/2)
        positionAnimation.toValue = CGPoint(x: 0, y: 0)
        positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        positionAnimation.duration = duration
        let sizeAnimation = CASpringAnimation(keyPath: "transform.scale")
        sizeAnimation.fromValue = 0
        sizeAnimation.toValue = 1
        sizeAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        sizeAnimation.duration = duration
        
        sizeAnimation.setValue("in", forKey: "tag")
        sizeAnimation.delegate = self
        
        blob.transform = CATransform3DMakeScale(1, 1, 1)
        blob.position = CGPoint(x: 0, y: 0)
        CATransaction.begin()
        blob.add(positionAnimation, forKey: #keyPath(CALayer.position))
        blob.add(sizeAnimation, forKey: "transform.scale")
        CATransaction.commit()
        blob.isHidden = false
    }
    
    private func animateOut(duration: TimeInterval) {
        let positionAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.fromValue = CGPoint(x: 0, y: 0)
        positionAnimation.toValue = CGPoint(x: -frame.width, y: -frame.height)
        positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        positionAnimation.duration = duration
        let sizeAnimation = CABasicAnimation(keyPath: "transform.scale")
        sizeAnimation.fromValue = 1
        sizeAnimation.toValue = 3
        sizeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        sizeAnimation.duration = duration

        sizeAnimation.setValue("out", forKey: "tag")
        sizeAnimation.delegate = self

        blob.transform = CATransform3DMakeScale(4, 4, 1)
        blob.position = CGPoint(x: -frame.width*1.5, y: -frame.height*1.5)
        CATransaction.begin()
        blob.add(positionAnimation, forKey: #keyPath(CALayer.position))
        blob.add(sizeAnimation, forKey: "transform.scale")
        CATransaction.commit()
    }
    
    private func fadeOut(duration: TimeInterval) {
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.duration = duration
        opacityAnimation.isRemovedOnCompletion = false
        
        opacityAnimation.setValue("fade", forKey: "tag")
        opacityAnimation.delegate = self
        
        blob.opacity = 0
        blob.add(opacityAnimation, forKey: #keyPath(CALayer.opacity))
    }
    
    private func setupViews() {
        layer.addSublayer(blob)
    }
    
    override func layoutSubviews() {
        initializeBlob(frame: frame)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        switch anim.value(forKey: "tag") as? String {
        case "in":
            animateOut(duration: animationDuration * 0.125)
        case "out":
            if doFadeOut {
                fadeOut(duration: animationDuration * 0.375)
            } else {
                animationCompletion?()
            }
        case "fade":
            animationCompletion?()
        default:
            animationCompletion?()
        }
    }
}
