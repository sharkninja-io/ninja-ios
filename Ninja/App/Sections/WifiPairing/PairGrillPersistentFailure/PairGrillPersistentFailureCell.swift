//
//  PairGrillPersistentFailureCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/5/22.
//

import UIKit

class PairGrillPersistentFailureCell: BaseTableViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var title: String = "" {
        didSet {
            updateText()
        }
    }
    var info: String = ""{
        didSet {
            updateText()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.selectionStyle = .none
        titleLabel.setStyle(.collectionViewCellLabel)
    }
    
    private func updateText() {
        titleLabel.attributedText = NSMutableAttributedString()
            .appendText(title, font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16), foregroundColor: ColorThemeManager.shared.theme.primaryTextColor)
            .appendText(" ", font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16), foregroundColor: ColorThemeManager.shared.theme.primaryTextColor)
            .appendText(info, font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16), foregroundColor: ColorThemeManager.shared.theme.primaryTextColor)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        updateText()
    }
    
    override func setupConstraints() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
}
