//
//  SettingsView.swift
//  Ninja
//
//  Created by Martin Burch on 8/21/22.
//

import UIKit

class SettingsLandingView: BaseView {
    
    @UsesAutoLayout public var tableView: UITableView = UITableView()
    
    // Loading
    private lazy var loadingSpinnerView: ActivityWorkingView = {
        let view = ActivityWorkingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.overlayColor = 0x000000.hexToUIColor(alpha: 0.0)
        return view
    }()
    private lazy var loadingOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isSpinning = false
    
    override func setupViews() {
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.VIEW_ID)
    }
    
    override func setupConstraints() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
     }
    
    override func refreshStyling() {
        tableView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
    }
    
    // Loading Overlay Functions
    func startLoadingOverlay() {
        addSubview(loadingOverlayView)
        addSubview(loadingSpinnerView)
        NSLayoutConstraint.activate(loadingOverlayView.constraintsForAnchoringTo(boundsOf: self))
        NSLayoutConstraint.activate(loadingSpinnerView.constraintsForAnchoringTo(boundsOf: loadingOverlayView))
        loadingOverlayView.backgroundColor = .black.withAlphaComponent(0.66)
        loadingSpinnerView.start()
        isSpinning = true
    }
    
    func interruptLoadingOverlay(_ completion: (() -> ())? = nil) {
        loadingSpinnerView.stop()
        loadingOverlayView.removeFromSuperview()
        loadingSpinnerView.removeFromSuperview()
        isSpinning = false
        completion?()
    }
    
    func completeLoadingOverlay(_ completion: (() -> ())? = nil) {
        loadingSpinnerView.complete() { [weak self] in
            self?.loadingOverlayView.removeFromSuperview()
            self?.loadingSpinnerView.removeFromSuperview()
            self?.isSpinning = false
            completion?()
        }
    }
}
