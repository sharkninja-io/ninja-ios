// adapted from https://stackoverflow.com/questions/42106980/how-to-present-a-viewcontroller-on-half-screen

import UIKit

class PartialPresentationController: UIPresentationController {

    internal var blurEffectView: UIVisualEffectView?
    var blurAlpha: CGFloat = 0.8
    
    internal var _presentationHeight: CGFloat = 1
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
    
    internal var _heightPercent: CGFloat? = 0.7
    var heightPercent: CGFloat? {
        get {
            return _heightPercent
        }
        set {
            if let newValue = newValue {
                _heightPercent = min(max(newValue, 0), 1)
            }
        }
    }

    var cornerRadius: CGFloat = 22 {
        didSet {
            containerView?.layoutIfNeeded()
        }
    }
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        _presentationHeight = height
        _heightPercent = nil
    }
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, percent: CGFloat) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        heightPercent = percent
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        initContainerView()
    }
    
    internal func initContainerView() {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        if let blurEffectView = blurEffectView {
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.isUserInteractionEnabled = true
            blurEffectView.addGestureRecognizer(tapGestureRecognizer)
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
  
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        if let presentedView = presentedView {
            presentedView.layer.mask = generateRoundedLayerMask(bounds: presentedView.bounds, corners: [.topLeft, .topRight], radius: cornerRadius)
        }
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        if let containerView = containerView {
            presentedView?.frame = CGRect(origin: CGPoint(x: 0, y: containerView.frame.height - presentationHeight),
                                          size: CGSize(width: containerView.frame.width, height: presentationHeight))
            blurEffectView?.frame = containerView.bounds
        }
    }

    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    internal func generateRoundedLayerMask(bounds: CGRect, corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: bounds,
                                 byRoundingCorners: corners,
                                 cornerRadii: CGSize(width: radius, height: radius)).cgPath
        return mask
    }
}

class PartialPresentationControllerDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var heightPercent: CGFloat = 1
    
    convenience init(heightPercent: CGFloat) {
        self.init()
        self.heightPercent = heightPercent
    }
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartialPresentationController(presentedViewController: presented, presenting: presenting, percent: heightPercent)
    }

}
