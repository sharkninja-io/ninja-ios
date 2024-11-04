//
//  RTFView.swift
//  Ninja
//
//  Created by Richard Jacobson on 6/19/23.
//

import UIKit

class RTFView: BaseView {
    
    @UsesAutoLayout var scrollView = UIScrollView()
    @UsesAutoLayout var copyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
        
    override func setupConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(copyLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 28),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            copyLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            copyLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            copyLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            copyLabel.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            copyLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            copyLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            
            copyLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            copyLabel.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).usingPriority(.defaultLow),
        ])
    }
}
