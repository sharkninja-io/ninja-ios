//
//  ExploreCookTimeFilterTableViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/14/23.
//

import UIKit

class ExploreCookTimeFilterTableViewCell: BaseTableViewCell {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }

    internal var titleLabel: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.text = "Cook Time".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var recipeTimeVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2.0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var lessThanFifteenMinutesCheckBox: Checkbox =  {
        let box = Checkbox(type: .custom)
        box.addRightLabel(value: "< 15 min", spacing: 100)
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    internal var fifteenToThirtyMinutesCheckBox: Checkbox =  {
        let box = Checkbox(type: .custom)
        box.addRightLabel(value: "15 - 30 min", spacing: 130)
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    internal var thirtyToSixtyMinutesCheckBox: Checkbox =  {
        let box = Checkbox(type: .custom)
        box.addRightLabel(value: "30 - 60 min", spacing: 130)
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    internal var sixtyToOneTwentyMinutesCheckBox: Checkbox =  {
        let box = Checkbox(type: .custom)
        box.addRightLabel(value: "60 - 120 min", spacing: 130)
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    internal var oneTwentyMinutesPlusCheckBox: Checkbox =  {
        let box = Checkbox(type: .custom)
        box.addRightLabel(value: "+120 min", spacing: 100)
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    
    internal var firstColumnVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16.0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var secondColumnVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16.0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    override func setupViews() {
        lessThanFifteenMinutesCheckBox.onEvent { _ in self.refreshStyling() }
        fifteenToThirtyMinutesCheckBox.onEvent { _ in self.refreshStyling() }
        thirtyToSixtyMinutesCheckBox.onEvent { _ in self.refreshStyling() }
        sixtyToOneTwentyMinutesCheckBox.onEvent { _ in self.refreshStyling() }
        oneTwentyMinutesPlusCheckBox.onEvent { _ in self.refreshStyling() }
        self.selectionStyle = .none
    }
        
    override func refreshStyling() {
        super.refreshStyling()
        titleLabel.setStyle(.pageIndicatorTitleLabel, theme: theme())
        lessThanFifteenMinutesCheckBox.tintColor = lessThanFifteenMinutesCheckBox.isChecked ? theme().primaryAccentColor : theme().primaryTextColor 
        fifteenToThirtyMinutesCheckBox.tintColor = fifteenToThirtyMinutesCheckBox.isChecked ? theme().primaryAccentColor : theme().primaryTextColor
        thirtyToSixtyMinutesCheckBox.tintColor = thirtyToSixtyMinutesCheckBox.isChecked ? theme().primaryAccentColor : theme().primaryTextColor
        sixtyToOneTwentyMinutesCheckBox.tintColor = sixtyToOneTwentyMinutesCheckBox.isChecked ? theme().primaryAccentColor : theme().primaryTextColor
        oneTwentyMinutesPlusCheckBox.tintColor = oneTwentyMinutesPlusCheckBox.isChecked ? theme().primaryAccentColor : theme().primaryTextColor

    }

    override func setupConstraints() {
   
        firstColumnVStack.addArrangedSubview(lessThanFifteenMinutesCheckBox)
        firstColumnVStack.addArrangedSubview(fifteenToThirtyMinutesCheckBox)
        firstColumnVStack.addArrangedSubview(thirtyToSixtyMinutesCheckBox)
        
        secondColumnVStack.addArrangedSubview(sixtyToOneTwentyMinutesCheckBox)
        secondColumnVStack.addArrangedSubview(oneTwentyMinutesPlusCheckBox)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstColumnVStack)
        contentView.addSubview(secondColumnVStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            firstColumnVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstColumnVStack.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 24),
            secondColumnVStack.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 24),
            secondColumnVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -144),
        ])
    }
}
