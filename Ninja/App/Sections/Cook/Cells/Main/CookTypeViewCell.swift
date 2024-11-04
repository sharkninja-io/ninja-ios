//
//  CookTypeViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 5/10/23.
//

import UIKit

class CookTypeViewCell: CookControlsViewCell {
    
    var currentCalculatedState: CalculatedState?
    var borderColor: UIColor?

    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        if let data = data as? CookCellItem<CookType> {
            data.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] cookType in
                let cookType: CookType = cookType == .ProbeSingle ? .ProbeDouble : cookType ?? .Unknown
                self?.tabBar.selectButton(doSendAction: false, completion: { $0.identifier as? CookType == cookType })
            }.store(in: &disposables)
            data.extrasSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
                guard let self = self else { return }
                if let state = state as? GrillState {
                    if state.state != self.currentCalculatedState {
                        let bounds = CGRect(origin: .zero,
                                            size: CGSize(width: self.tabBar.bounds.width / CGFloat(self.tabBar.buttonList.count),
                                                         height: self.tabBar.bounds.height))
                        let labelColors = MonitorControlColors.getColorSet(state: state.state).labelColors
                        self.borderColor = UIColor.getGradientAsColor(rect: bounds, colors: labelColors) ?? .white
                        self.currentCalculatedState = state.state
                    }
                }
            }.store(in: &disposables)
            
            tabBar.onEvent { [weak self] control in
                guard let self = self else { return }
                data.onClick?(control, self.tabBar.selectedButton?.identifier)
            }
        }
    }
    
    var tabBar: ToggleButtonGroup = {
        let group = ToggleButtonGroup()
        group.translatesAutoresizingMaskIntoConstraints = false
        return group
    }()

    override func setupViews() {
        super.setupViews()
        
        tabBar.addButtons([
            OvalToggleButton(title: "TIMED COOK".uppercased(), identifier: CookType.Timed),
            OvalToggleButton(title: "THERMOMETER".uppercased(), identifier: CookType.ProbeDouble)
        ])
        tabBar.selectButton(tabBar.buttonList.first)
    }
    
    override func setupConstraints() {
        contentView.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            tabBar.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            tabBar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            tabBar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
         ])
    }

    override func refreshStyling() {
        super.refreshStyling()
        
        self.backgroundColor = .clear
        tabBar.setStyle(backgroundColor: theme().cellCookBackground,
                        borderWidth: 1,
                        borderColor: theme().cookToggleBorderColor,
                        cornerRadius: DefaultSizes.buttonCornerRadius)
        tabBar.buttonList.forEach { button in
            button.setStyle(.ovalTabButton(borderColor: borderColor), theme: theme())
        }
    }
}
