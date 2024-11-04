//
//  SimplePickerView.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/22/22.
//

import UIKit

class SimplePickerView: BaseView {
    
    // UI Objects
    @UsesAutoLayout var bgOverlayView = UIView()
    
    @UsesAutoLayout var containerView = UIView()
    @UsesAutoLayout var pickerView = UIPickerView()
    @UsesAutoLayout var doneButton = UIButton()
    
    // Animation Constraints
    private lazy var containerHiddenConstraints: [NSLayoutConstraint] = [
        containerView.topAnchor.constraint(equalTo: bottomAnchor, constant: 20),
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 600),
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 600)
    ]
    
    private lazy var containerPresentedConstraints: [NSLayoutConstraint] = [
        containerView.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: -48),
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        pickerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        initialPresentation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Animate the from below the sceren to the middle
    private func initialPresentation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            NSLayoutConstraint.deactivate(self.containerHiddenConstraints)
            NSLayoutConstraint.activate(self.containerPresentedConstraints)
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
                self.bgOverlayView.backgroundColor = .black.withAlphaComponent(0.66)
                self.layoutIfNeeded()
            }
        }
    }
    
    /// Animated dismissal of the contentView without animated the darkened background
    public func customDismiss(_ callback: @escaping (() -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            NSLayoutConstraint.deactivate(self.containerPresentedConstraints)
            NSLayoutConstraint.activate(self.containerHiddenConstraints)
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
                self.bgOverlayView.backgroundColor = .clear
                self.layoutIfNeeded()
            } completion: { _ in callback() }
        }
    }
    
    override func setupViews() {
        addSubview(bgOverlayView)
        addSubview(containerView)
        addSubview(pickerView)
        addSubview(doneButton)
        
        bgOverlayView.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 16
        
        doneButton.setTitle("Done", for: .normal)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate(containerHiddenConstraints)
        NSLayoutConstraint.activate([
            bgOverlayView.topAnchor.constraint(equalTo: topAnchor),
            bgOverlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgOverlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            doneButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    override func refreshStyling() {
        containerView.backgroundColor = ColorThemeManager.shared.theme.grey04
        // TODO: - FIX
        doneButton.setStyle(ButtonStyle {_ in .init(textColor: .systemBlue, font: .systemFont(ofSize: 18, weight: .semibold))})
    }
}
