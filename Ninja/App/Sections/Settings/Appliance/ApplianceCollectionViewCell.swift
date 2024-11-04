//
//  ApplianceCollectionViewCell.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/19/22.
//

import UIKit

class ApplianceCollectionViewCell: UICollectionViewCell {
    
    @UsesAutoLayout private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @UsesAutoLayout private var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout private var subtitleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshStyling()
    }
    
    private func setupViews() {
        addSubview(bgView)
        addSubview(vStack)
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            bgView.heightAnchor.constraint(equalToConstant: 136),
            
            imageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -15),
            imageView.topAnchor.constraint(equalTo: bgView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.4),
            
            vStack.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 24),
            vStack.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -20),
            vStack.trailingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
    }
    
    private func refreshStyling() {
        bgView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        bgView.layer.borderColor = ColorThemeManager.shared.theme.primaryForegroundColor.cgColor
        
        titleLabel.setStyle(.infoLabel)
        subtitleLabel.setStyle(.itemLabel)
    }
    
    func connectData(_ grill: Grill) {
        titleLabel.text = grill.getName()
        Task {
            let modelNumber = await grill.details().unwrapOrNil()?.modelNumber
            subtitleLabel.text = modelNumber
        }
        imageView.image = ImageAssetLibrary.img_ogxl_angled.asImage()
        
    }
}
