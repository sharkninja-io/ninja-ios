//
//  BaseViewController.swift
//  Ninja
//
//  Created by Martin Burch on 8/19/22.
//

import UIKit
import Combine

class BaseViewController<T: UIView>: UIViewController {
    
    var subview: T!
    var disposables = Set<AnyCancellable>()
    private var keyboardSizeObserver: KeyboardSizeObserver? = KeyboardSizeObserver()
    var keyboardSizeObserverDelegate: KeyboardSizeObserverDelegate? = nil
    private var backgroundObserver: BackgroundObserver? = nil
    
    /// Hides the custom back button if set to `true`. Will be `false` by default unless the VC is first in the navigation stack.
    lazy var hideBackButton: Bool = {
        if navigationController?.viewControllers.first == self {
            return true
        } else {
            return false
        }
    }()
    
    var hideExitButton: Bool = true
    
    override func loadView() {
        super.loadView()
        
        subview = .init(frame: view.bounds)
        self.view = subview
        
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHideKeyboardOnTapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = title
        navigationItem.title = ""
        super.viewWillAppear(animated)
        
        subscribeToSubjects()
        addKeyboardObserver()
        backgroundObserver = BackgroundObserver(appWillResignActive, appWillEnterForeground)
        backgroundObserver?.start()
         
        // update style when bounds is not 0
        if let navigationBar = navigationController?.navigationBar {
            NavigationBarStyling.styleNavBar(navigationBar: navigationBar)
        }
        if let tabBar = tabBarController?.tabBar {
            TabBarStyling.styleTabBar(tabBar: tabBar)
        }
        checkBackButton()
        checkExitButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        backgroundObserver?.stop()
        backgroundObserver = nil
        keyboardSizeObserver?.stopObserving()
        unsubscribeFromSubjects()
        keyboardSizeObserver = nil
        navigationItem.leftBarButtonItem = nil
        super.viewWillDisappear(animated)
    }
    
    deinit {
    }
    
    internal func setupViews() {
    }
    
    internal func subscribeToSubjects() {
    }
    
    internal func unsubscribeFromSubjects() {
        disposables.removeAll()
    }
    
    func addKeyboardObserver() {
         if let delegate = keyboardSizeObserverDelegate {
             keyboardSizeObserver?.delegate = delegate
             keyboardSizeObserver?.startObserving()
        }
    }
    
    func appWillResignActive() { }
    
    func appWillEnterForeground() { }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != ColorThemeManager.shared.currentStyle {
            interfaceStylingUpdate()
        }
    }
    
    internal func interfaceStylingUpdate() {
        DispatchQueue.main.async { [weak self] in
            if let navigationBar = self?.navigationController?.navigationBar {
                NavigationBarStyling.styleNavBar(navigationBar: navigationBar)
            }
            if let tabBar = self?.tabBarController?.tabBar {
                TabBarStyling.styleTabBar(tabBar: tabBar)
            }
        }
    }
    
    func checkBackButton() {
        navigationItem.hidesBackButton = true
        if !hideBackButton {
            NavigationBarStyling.setupBackButton(navigationItem: navigationItem, target: self, action: #selector(didTapBackButton))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func checkExitButton() {
        if !hideExitButton {
            NavigationBarStyling.setupExitButton(navigationItem: navigationItem, target: self, action: #selector(didTapExitButton))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func didTapBackButton() {
        backButtonBehavior()
    }
    
    @objc func didTapExitButton() {
        exitButtonBehavior()
    }
    
    /// Action executed when the custom back button is tapped. By default it simply pops the viewController. Override to change.
    func backButtonBehavior() {
        navigationController?.popViewController(animated: true)
    }
    
    func exitButtonBehavior() {
        self.dismiss(animated: true)
    }
}
