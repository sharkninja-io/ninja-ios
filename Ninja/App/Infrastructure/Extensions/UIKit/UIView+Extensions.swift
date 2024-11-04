//
//  XIBs+Extensions.swift
//  SharkClean
//
//  Created by Jonathan on 12/28/21.
//

import UIKit

extension UIView {
    // TODO: rename to VIEW_IDENTIFIER
    public class var VIEW_ID: String {
        return String.init(describing: self)
    }
    
    private func xib(with name: String, owner: Any) -> UIView? {
        let nib = UINib(nibName: name, bundle: .main)
        guard let content = nib.instantiate(withOwner: owner, options: nil)[0] as? UIView else {
            return nil
        }; return content
    }
    
    public func initXIB(with name: String, owner: Any) {
        if let subview = xib(with: name, owner: owner) {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
                subview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
                subview.centerYAnchor.constraint(equalTo: centerYAnchor),
                subview.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
    
    public func initScrollableXIB(with name: String, owner: Any, requiredHeight: CGFloat = 720) {
        Logger.Ui(self.bounds)

        if self.bounds.height >= requiredHeight {
            initXIB(with: name, owner: owner)
        } else if let subview = xib(with: name, owner: owner) {
            let scroll = UIScrollView()
            scroll.alwaysBounceHorizontal = false
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false

            scroll.translatesAutoresizingMaskIntoConstraints = false
            subview.translatesAutoresizingMaskIntoConstraints = false

            addSubview(scroll)
            scroll.addSubview(subview)
 
            NSLayoutConstraint.activate([
                scroll.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                scroll.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                scroll.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                scroll.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

                subview.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
                subview.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
                subview.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),

                subview.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor),
                subview.heightAnchor.constraint(equalToConstant: requiredHeight),

            ])
        }
    }
    
}
