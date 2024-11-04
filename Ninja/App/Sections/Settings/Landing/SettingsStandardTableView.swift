//
//  StartandSettingsTableView.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

class SettingsStandardTableView: BaseView {
    
    // MARK: Views
    @UsesAutoLayout var scrollView = UIScrollView()
    @UsesAutoLayout var contentView = UIView()
    
    @UsesAutoLayout var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var subtitleLabel = UILabel()
    @UsesAutoLayout public var tableView = UITableView()
    
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
        
    override func setupViews() {
        scrollView.pinTo(superView: self, withContentView: contentView)
        contentView.addSubview(vStack)
        contentView.addSubview(tableView)
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.VIEW_ID)
        tableView.register(ProfileTextFieldCell.self, forCellReuseIdentifier: ProfileTextFieldCell.VIEW_ID)
        tableView.register(ProfileFooterCell.self, forCellReuseIdentifier: ProfileFooterCell.VIEW_ID)
        tableView.register(ApplianceDetailCell.self, forCellReuseIdentifier: ApplianceDetailCell.VIEW_ID)
        tableView.register(ErrorLogCell.self, forCellReuseIdentifier: ErrorLogCell.VIEW_ID)
        tableView.isScrollEnabled = false
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DefaultSizes.topPadding),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            tableView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        tableView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        titleLabel.setStyle(.settingsTitle)
        subtitleLabel.setStyle(.settingsSubtitle)
    }
    
    public func setTitles(title: String? = nil, subtitle: String? = nil) {
        if let title {
            titleLabel.text = title.uppercased()
            vStack.addArrangedSubview(titleLabel)
        }
        
        if let subtitle {
            subtitleLabel.text = subtitle
            vStack.addArrangedSubview(subtitleLabel)
        }
    }
    
    func startLoadingOverlay() {
        addSubview(loadingOverlayView)
        addSubview(loadingSpinnerView)
        NSLayoutConstraint.activate(loadingOverlayView.constraintsForAnchoringTo(boundsOf: self))
        NSLayoutConstraint.activate(loadingSpinnerView.constraintsForAnchoringTo(boundsOf: loadingOverlayView))
        loadingOverlayView.backgroundColor = .black.withAlphaComponent(0.66)
        loadingSpinnerView.start()
    }
    
    func interruptLoadingOverlay(_ completion: (() -> ())? = nil) {
        loadingSpinnerView.stop()
        loadingOverlayView.removeFromSuperview()
        loadingSpinnerView.removeFromSuperview()
        completion?()
    }
    
    func completeLoadingOverlay(_ completion: (() -> ())? = nil) {
        loadingSpinnerView.complete() { [weak self] in
            self?.loadingOverlayView.removeFromSuperview()
            self?.loadingSpinnerView.removeFromSuperview()
            completion?()
        }
    }
}
