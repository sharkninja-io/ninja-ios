//
//  MultiToggleButtonGroupController.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/15/23.
//

import UIKit

class MultiToggleButtonGroupController {
    
    var allowDeselect: Bool = false
    var allowSingleSelection: Bool = false
    
    private var _buttonList: [BaseToggleButton] = []
    
    var selectedButtonIdentifiers: [Any?] = []
    var identityComparer: (Any?, Any?) -> Bool = { _, _ in return true }
    
    var buttonList: [BaseToggleButton] {
        get {
            _buttonList
        }
    }
    
    private var _selectedButton: BaseToggleButton? = nil
    var selectedButton: BaseToggleButton? {
        get {
            _selectedButton
        }
    }
    
    var onSelectCallback: ((BaseToggleButton?) -> Void)? = nil
    var onRefreshCallback: ((BaseToggleButton?) -> Void)? = nil
    
    init(onSelect: ((BaseToggleButton?) -> Void)? = nil) {
        onSelectCallback = onSelect
    }
        
    func addButtons(_ buttonList: [BaseToggleButton]) {
        self._buttonList = buttonList
        setupButtons()
    }
    
    func addButton(_ button: BaseToggleButton) {
        self._buttonList.append(button)
        setupButtons()
    }
    
    func setupButtons() {
        buttonList.forEach { button in
            button.removeEvent()
            self.onRefreshCallback?(button)
            button.onEvent { [weak self] control in
                guard let self = self else { return }
                if let toggle = control as? BaseToggleButton {
                    if self.selectButton(toggle) {
                        self.onSelectCallback?(toggle)
                    }
                }
            }
        }
    }
    
    func isSelected(_ toggleButton: BaseToggleButton?) -> Bool {
        guard let toggleButton = toggleButton else { return false }
        
        return selectedButtonIdentifiers.contains(where: { identityComparer($0, toggleButton.identifier) })
    }
    
    
    func checkForSingleSelection(toggleButton: BaseToggleButton) {
        if allowSingleSelection {
            selectedButtonIdentifiers.removeAll()
            for button in buttonList {
                deselectButton(button)
            }
            selectedButtonIdentifiers.append(toggleButton.identifier)
            return
        }
    }
    
    func selectButton(_ toggleButton: BaseToggleButton?, canDeselect: Bool = true) -> Bool {
        guard let toggleButton = toggleButton else { return false }
        _selectedButton = toggleButton
        
        if !isSelected(toggleButton) || !canDeselect {
            checkForSingleSelection(toggleButton: toggleButton)
            selectedButtonIdentifiers.append(toggleButton.identifier)
            toggleButton.isSet = true
            return true
        } else if canDeselect {
            deselectButton(toggleButton)
            return true
        }
        return false
    }
    
    func deselectButton(_ toggleButton: BaseToggleButton?) {
        guard let toggleButton = toggleButton else { return }
        
        selectedButtonIdentifiers.removeAll { identityComparer($0, toggleButton.identifier) }
        toggleButton.isSet = false
    }
}
