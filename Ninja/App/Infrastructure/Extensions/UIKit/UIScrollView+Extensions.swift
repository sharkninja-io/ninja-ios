//
//  UIScrollView+Extensions.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/9/22.
//

import UIKit

extension UIScrollView {
    /// **Only for vertical scrolling.** Pin the `ScrollView` to the `safeAreaLayoutGuide` of the `superView`, then prepare the `contentView` to scroll within it.
    func pinTo(superView: UIView, withContentView contentView: UIView) {
        superView.addSubview(self)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor).usingPriority(.defaultLow),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: superView.heightAnchor).usingPriority(.defaultLow),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    
    /// **Only for vertical scrolling.** Pin the ScrollView to specific anchors, and prepare the `contentView` to scroll within it, but execute a given closure before activating constraints.
    ///
    /// - Parameters:
    ///   - superView: Optional view to which this `ScrollView` will be added as a subview.
    ///   - contentView: View containing the ScrollView's contents
    ///   - minimumContentHeight: Optional specific height to which to set the `contentView`. Will be `1000`, otherwise.
    ///   - preparationClosure: Optional closure to execute prior to activating constraints. Include the closure if this function will activate a constraint to an object that is not yet in the view hierarchy. Doing so this way may make for more readable code.
    func pinToAnchors(top: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, superView: UIView? = nil, withContentView contentView: UIView, minimumContentHeight: CGFloat? = nil, withPreparation preparationClosure: (() -> ())? = nil) {
        addSubview(contentView)
        
        if let superView { superView.addSubview(self) }
        
        preparationClosure?()
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top),
            leadingAnchor.constraint(equalTo: leading),
            trailingAnchor.constraint(equalTo: trailing),
            bottomAnchor.constraint(equalTo: bottom),
            
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor).usingPriority(.defaultLow),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.heightAnchor.constraint(equalToConstant: minimumContentHeight ?? 1000)
        ])
    }
}
