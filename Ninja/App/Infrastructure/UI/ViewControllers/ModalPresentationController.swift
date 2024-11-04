//
//  ModalPresentationController.swift
//  Ninja
//
//  Created by Martin Burch on 12/8/22.
//

import UIKit

class ModalPresentationController: UIPresentationController {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }

    internal var blurEffectView: UIVisualEffectView?
    var blurAlpha: CGFloat = 0.8
    
    internal var _presentationHeight: CGFloat = 100
    var presentationHeight: CGFloat {
        get {
            if let containerView = containerView {
                if let heightPercent = heightPercent {
                    return containerView.frame.height * heightPercent
                } else {
                    return min(_presentationHeight, containerView.frame.height)
                }
            }
            return 0
        }
    }
    var presentationWidthOffset: CGFloat = 48
    
    internal var _heightPercent: CGFloat? = nil
    var heightPercent: CGFloat? {
        get {
            return _heightPercent
        }
        set {
            if let newValue = newValue {
                _heightPercent = min(max(newValue, 0), 1)
            } else {
                _heightPercent = nil
            }
        }
    }

    var cornerRadius: CGFloat = 22 {
        didSet {
            containerView?.layoutIfNeeded()
        }
    }
    
    private var dismissable: Bool = true
    var dismissCompletion: (() -> Void)? = nil
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat, dismiss: Bool = true) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self._presentationHeight = height
        self._heightPercent = nil
        self.dismissable = dismiss
        setupBackground()
    }
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, percent: CGFloat, dismiss: Bool = true) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.heightPercent = percent
        self.dismissable = dismiss
        setupBackground()
     }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        initContainerView()
    }
    
    internal func initContainerView() {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        setupBackground()
    }
    
    internal func setupBackground() {
        if let blurEffectView = blurEffectView {
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.isUserInteractionEnabled = dismissable
            if dismissable {
                blurEffectView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
  
    override func presentationTransitionWillBegin() {
        if let blurEffectView = blurEffectView {
            blurEffectView.alpha = 0
            self.containerView?.addSubview(blurEffectView)
            self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
                guard let self = self else { return }
                blurEffectView.alpha = self.blurAlpha
            }, completion: { context in })
        }
    }
  
    override func dismissalTransitionWillBegin() {
        if let blurEffectView = blurEffectView {
            self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
                blurEffectView.alpha = 0
            }, completion: { context in
                blurEffectView.removeFromSuperview()
            })
        }
    }
  
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        if let containerView = containerView, let presentedView = presentedView {
            presentedView.frame = CGRect(
                origin: CGPoint(x: presentationWidthOffset / 2, y: (containerView.frame.height - presentationHeight) / 2),
                size: CGSize(width: containerView.frame.width - presentationWidthOffset, height: presentationHeight))
            presentedView.layer.cornerRadius = cornerRadius
            presentedView.layer.shadowColor = theme().grey01.cgColor
            presentedView.layer.shadowOffset = .zero
            presentedView.layer.shadowOpacity = 0.5
            presentedView.layer.shadowRadius = 4
            blurEffectView?.frame = containerView.bounds
        }
    }

    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
        dismissCompletion?()
    }
}

class ModalPresentationControllerDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var height: CGFloat = 400
    var dismissable: Bool = true
    var dismissCompletion: (() -> Void)? = nil
    
    convenience init(height: CGFloat = 400, dismiss: Bool = true) {
        self.init()
        self.height = height
        self.dismissable = dismiss
    }
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = ModalPresentationController(presentedViewController: presented, presenting: presenting, height: height, dismiss: dismissable)
        controller.dismissCompletion = dismissCompletion
        return controller
    }

}
