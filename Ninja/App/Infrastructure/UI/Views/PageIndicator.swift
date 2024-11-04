//
//  PageIndicator.swift
//  Ninja
//
//  Created by Martin Burch on 11/29/22.
//

import UIKit

@IBDesignable
class PageIndicator: BaseView {
    
    var visitedIndicatorColor: UIColor {
        get { ColorThemeManager.shared.theme.primaryAccentColor }
    }
    
    var unVisitedIndicatorColor: UIColor {
        get { ColorThemeManager.shared.theme.grey03 }
    }
    
    var currentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var indicatorStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    @IBInspectable
    var indicatorHeight: CGFloat = 4
    
    @IBInspectable
    var numberOfPages: Int = 3 {
        didSet {
            setupIndicators()
        }
    }
    
    @IBInspectable
    var currentPage: Int = 1 {
        didSet {
            setupIndicators()
        }
    }
    
    private var pageIndicators: [UIView] = []
    
    func generateVisitedIndicator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.layer.cornerRadius = 4
        return view
    }
    
    func generateUnvisitedIndicator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 4
        return view
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupIndicators()
    }
    
    internal func setupIndicators() {
        pageIndicators = []
        for index in Array(0..<numberOfPages) {
            pageIndicators.append(
                (index < currentPage) ? generateVisitedIndicator() : generateUnvisitedIndicator()
            )
        }
        for view in indicatorStack.arrangedSubviews {
            indicatorStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        pageIndicators.forEach { indicator in
            indicatorStack.addArrangedSubview(indicator)
        }
        
        currentLabel.text = "Step \(currentPage) "
        countLabel.text = "of \(numberOfPages)"
    }
    
    override func setupConstraints() {
        self.addSubview(indicatorStack)
        self.addSubview(currentLabel)
        self.addSubview(countLabel)
        self.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            indicatorStack.topAnchor.constraint(equalTo: self.topAnchor),
            indicatorStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indicatorStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            indicatorStack.bottomAnchor.constraint(equalTo: currentLabel.topAnchor, constant: -8),
            indicatorStack.heightAnchor.constraint(equalToConstant: indicatorHeight),
            currentLabel.topAnchor.constraint(equalTo: indicatorStack.bottomAnchor, constant: 8),
            currentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            currentLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            currentLabel.bottomAnchor.constraint(equalTo: pageTitleLabel.topAnchor, constant: -8),
            countLabel.topAnchor.constraint(equalTo: currentLabel.topAnchor),
            countLabel.leadingAnchor.constraint(equalTo: currentLabel.trailingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: currentLabel.bottomAnchor),
            pageTitleLabel.topAnchor.constraint(equalTo: currentLabel.bottomAnchor, constant: 8),
            pageTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pageTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    override func refreshStyling() {
        backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        for (index, indicator) in pageIndicators.enumerated() {
            indicator.backgroundColor = (index < currentPage) ? visitedIndicatorColor : unVisitedIndicatorColor
        }
        currentLabel.setStyle(.pageIndicatorLabel)
        countLabel.setStyle(.pageIndicatorLabel)
        pageTitleLabel.setStyle(.pageIndicatorTitleLabel)
        currentLabel.textColor = visitedIndicatorColor
        countLabel.textColor = unVisitedIndicatorColor
        pageTitleLabel.textColor = visitedIndicatorColor
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 200)
    }
    
}
