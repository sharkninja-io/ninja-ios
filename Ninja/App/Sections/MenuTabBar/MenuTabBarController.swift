//
//  MenuTabBarController.swift
//  Ninja
//
//  Created by Martin Burch on 8/21/22.
//

import UIKit
import Combine

class MenuTabBarController: UITabBarController {
    
    private var disposables = Set<AnyCancellable>()
    private var viewModel: MenuTabBarViewModel = .shared()
    private var authenticationViewModel: AuthenticationViewModel = .shared()
    private var backgroundObserver: BackgroundObserver?
    
    private var vc: MonitorControlModalViewController?
    private let modalDelegate = ModalPresentationControllerDelegate()
    
    private var checkNotificationsOnLogin: Bool = false

    class CustomTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var size = super.sizeThatFits(size)
            size.height = size.height + DefaultSizes.menubarTopOffset
            return size
        }
    }
    
    override func loadView() {
        super.loadView()
        
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        delegate = self

        viewControllers = MenuTabBarItems.viewControllers.map { UINavigationController(rootViewController: $0) }
        selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        backgroundObserver = BackgroundObserver(appWillResignActive, appWillEnterForeground)
        backgroundObserver?.start()

        authenticationViewModel.isLoggedInSubject.receive(on: DispatchQueue.main).sink { [weak self] isLoggedIn in
            guard let self = self else { return }
            self.checkNotificationsOnLogin = isLoggedIn
            if isLoggedIn {
            } else {
                self.viewModel.clearDevices()
                self.toLogin()
            }
        }.store(in: &disposables)

        viewModel.devicesSubject.receive(on: DispatchQueue.main).sink { [weak self] grills in
            guard let self = self, let grills = grills else { return }
            if grills.count == 0 {
                NavigationManager.shared.toBTPairing(viewController: self)
            } else {
                // Has grills, are subscribed, not initialized
                if self.viewModel.isAnySubscribed() && !self.viewModel.isNotificationTokenRegistered() {
                    Task {
                        await self.viewModel.initNotifications()
                    }
                // Has grills, are not subscribed, user subscribed, check on login
                } else if self.checkNotificationsOnLogin && self.viewModel.userReceivesCookNotifications() && !self.viewModel.isAnySubscribed() {
                    self.viewModel.subscribeAllToNotifications()
                }
            }
            // Kill check on device load
            self.checkNotificationsOnLogin = false
        }.store(in: &disposables)
        
        viewModel.devicesErrorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            guard let self = self else { return }
            if error.errorType == .notAuthorized {
                self.toLogin()
            }
        }.store(in: &disposables)
        
        //        viewModel.currentStateSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] state in
        //            let currentGrill = self?.viewModel.currentGrillSubject.value
        //            // TODO: FUTURE - when we can monitor multiple grills
        //              if self?.selectedIndex != 1 {
        //                if state?.state == .Done {
        //                    let name = currentGrill?.getName() ?? "Grill"
        //                    self?.showCookComplete(grillName: name)
        //                } else if state?.probe1.state == .Done {
        //                    self?.showThermometerComplete(index: 1)
        //                } else if state?.probe2.state == .Done {
        //                    self?.showThermometerComplete(index: 2)
        //                }
        //              }
        //        }.store(in: &disposables)

        if NavigationManager.shared.isBLEDenied() {
            NavigationManager.shared.setBLEDenied(denied: false)
            NavigationManager.shared.toBTPairing(viewController: self)
        }
        viewModel.pairingCompleted.receive(on: DispatchQueue.main).sink { [weak self] dsn in
            self?.selectedIndex = 1
            self?.showNotificationsPrompt()
        }.store(in: &disposables)
        
        viewModel.loadDevices()
    }
    
    func appWillEnterForeground() {
        viewModel.startMonitoring()
    }

    func appWillResignActive() {
        viewModel.stopMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposables.removeAll()
        
        backgroundObserver?.stop()
        backgroundObserver = nil
    }
    
    private func toLogin() {
        NavigationManager.shared.toAuthentication(window: self.view.window)
    }
}

// MARK: TRANSITIONS
extension MenuTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let fromView = selectedViewController?.view,
           let toView = viewController.view,
            fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve])
        }
        
        return true
    }
}

extension MenuTabBarController {
    
    func showNotificationsPrompt() {
        showModal(
            title: "Turn on notifications?",
            description: "You will receive real-time notifications about the status of your grill and cook.",
            primaryText: "Yes, keep me informed!",
            secondaryText: "I don't want to be notified",
            delegate: modalDelegate,
            dismissable: false,
            completion: { [weak self] in
                guard let self = self else { return }
                self.viewModel.subscribeAllToNotifications()
            }, cancelCompletion: {
                Task {
                    await self.viewModel.unsubscribeAllNotifications()
                }
            })
    }
    
// MARK: DIALOGS - TODO: when we have the ability to monitor multiple grills
//    func showCookComplete(grillName: String) {
//        showModal(
//            title: "Cook Complete",
//            description: "\(grillName) has completed its cook.",
//            primaryText: "Check it out".uppercased(),
//            secondaryText: "OKAY".uppercased(),
//            delegate: modalDelegate,
//            height: 250,
//            completion: { [weak self] in
//                self?.selectedIndex = 1
//            })
//    }
//
//    func showThermometerComplete(index: Int) {
//        showModal(
//            title: "Cook Complete",
//            description: "Thermometer \(index): We’ve reached your set resting temperature.",
//            primaryText: "Check it out".uppercased(),
//            secondaryText: "OKAY".uppercased(),
//            delegate: modalDelegate,
//            height: 250,
//            completion: { [weak self] in
//                self?.selectedIndex = 1
//            })
//    }

    private func showModal(title: String, description: String, primaryText: String?, secondaryText: String?, delegate: ModalPresentationControllerDelegate, height: CGFloat = 300, dismissable: Bool = true, completion: (() -> Void)?, cancelCompletion: (() -> Void)? = nil) {
        vc = MonitorControlModalViewController()
        if let vc = vc {
            vc.modalTitle = title
            vc.modalDescription = description
            vc.primaryButtonText = primaryText
            vc.secondaryButtonText = secondaryText
            vc.successCompletion = completion
            vc.cancelCompletion = cancelCompletion
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = delegate
            delegate.dismissCompletion = cancelCompletion
            delegate.height = height
            delegate.dismissable = dismissable
            self.present(vc, animated: true)
        }
    }
}
