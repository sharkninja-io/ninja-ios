//
//  ViewController+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/6/22.
//

import UIKit

extension UIViewController {
    
    func addToParentController(_ parentController: UIViewController, layoutClosure: ((UIViewController, UIViewController) -> ())?) {
        parentController.addChild(self)
        parentController.view.addSubview(self.view)
        self.view.frame = parentController.view.bounds
        layoutClosure?(parentController, self)
        self.didMove(toParent: parentController)
    }
    
    func removeFromParentController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}

extension UIViewController {
    
    func addHideKeyboardOnTapView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
