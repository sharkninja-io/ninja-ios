//
//  KeyboardObserver.swift
//  SharkClean
//
//  Created by Jonathan on 1/27/22.
//

import UIKit

@objc protocol KeyboardSizeObserverDelegate: AnyObject {
    func keyboardWillShow(_ rect: CGRect)
    func keyboardWillHide(_ rect: CGRect)
}

final class KeyboardSizeObserver {
    
    public weak var delegate: KeyboardSizeObserverDelegate?

    init(_ delegate: KeyboardSizeObserverDelegate? = nil) {
        self.delegate = delegate
    }
    
    public func startObserving() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardIsPresented),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardIsDismissed),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    public func stopObserving() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        delegate = nil
        stopObserving()
    }
    
    @objc private func keyboardIsPresented(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                  return
        }
        delegate?.keyboardWillShow(keyboardSize.cgRectValue)
    }
    
    @objc private func keyboardIsDismissed(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                  return
        }
        delegate?.keyboardWillHide(keyboardSize.cgRectValue)
    }
}

class DefaultKeyboardSizeObserverDelegate: KeyboardSizeObserverDelegate {
    private var view: UIView
    private var maxY: CGFloat
    private var textFields: [UITextField]
    private var keyboardPadding: CGFloat
    
    var duration: Double = 0.2
    
    init(view: UIView, for textFields: [UITextField], maxY: CGFloat, keyboardPadding: CGFloat = 0) {
        self.view = view
        self.textFields = textFields
        self.maxY = maxY
        self.keyboardPadding = keyboardPadding
    }
    
    
    func keyboardWillShow(_ rect: CGRect) {
        let firstResponder = textFields.filter { textField in return textField.isFirstResponder }
        if firstResponder.count > 0 {
            let keyboardTop = rect.minY
            let translation = keyboardTop - keyboardPadding - maxY
            if translation < 0 {
                UIView.animate(withDuration: duration) {
                    self.view.transform = .init(translationX: 0, y: translation)
               }
            }
        } else {
            UIView.animate(withDuration: duration) {
                self.view.transform = .identity
            }
        }

    }
    
    func keyboardWillHide(_ rect: CGRect) {
        view.transform = .identity
    }

}
