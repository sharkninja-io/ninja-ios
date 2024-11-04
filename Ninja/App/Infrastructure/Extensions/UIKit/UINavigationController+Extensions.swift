//
//  UINavigationController+Extensions.swift
//  SharkClean
//
//  Created by Jonathan on 1/12/22.
//

import UIKit

extension UINavigationController {
    func popToViewController<T: UIViewController>(toControllerType: T.Type, animated: Bool = true) {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController.isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: animated)
                return
            }
        }
    }
    
    func getViewControllerFromStack<T: UIViewController>(controllerType: T.Type) -> UIViewController? {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController.isKind(of: controllerType) {
                return currentViewController
            }
        }; return nil
    }
    
    func isViewControllerFirst(controller: UIViewController?) -> Bool {
        let viewControllers: [UIViewController] = self.viewControllers
        return controller == viewControllers.first
    }
    
    func isPreviousViewController<T: UIViewController>(controllerType: T.Type) -> Bool {
        let viewControllers: [UIViewController] = self.viewControllers
        guard viewControllers.count > 2 else {
            return viewControllers.first!.isKind(of: controllerType)
        }
        return viewControllers[viewControllers.count - 2].isKind(of: controllerType)
    }
    
    func getPreviousViewController<T: UIViewController>(controllerType: T.Type) -> T? {
        let viewControllers: [UIViewController] = self.viewControllers
        guard viewControllers.count > 2 else {
            let isFirstControllerAndOfType = viewControllers.first!.isKind(of: controllerType)
            return isFirstControllerAndOfType ? viewControllers.first! as? T : nil
        }
        let isControllerAndOfType = viewControllers[viewControllers.count - 2].isKind(of: controllerType)
        return isControllerAndOfType ? viewControllers[viewControllers.count - 2] as? T : nil
    }
}

// MARK: Status Bar Styling
extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle ?? .default
    }
}
