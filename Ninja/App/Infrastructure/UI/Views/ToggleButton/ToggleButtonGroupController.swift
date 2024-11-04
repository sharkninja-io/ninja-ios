//
//  ToggleButtonGroupController.swift
//  Ninja
//
//  Created by Martin Burch on 12/29/22.
//

import UIKit

class ToggleButtonGroupController {
    
    var allowDeselect: Bool = false
    
    private var _buttonList: [BaseToggleButton] = []
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
    var onTapCallback: ((BaseToggleButton?) -> Void)? = nil
    
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
            button.onEvent { [weak self] control in
                guard let self = self else { return }
                if let toggle = control as? BaseToggleButton {
                    if self.selectButton(toggle) {
                        self.onSelectCallback?(toggle.isSet ? toggle : nil)
                    }
                    self.onTapCallback?(toggle)
                }
            }
        }
    }
    
    func selectButton(_ toggleButton: BaseToggleButton?, canDeselect: Bool = true) -> Bool {
        guard let toggleButton = toggleButton else { return false }
        
        var changed = false
        if toggleButton != self._selectedButton {
            buttonList.forEach { button in
                button.isSet = (toggleButton == button)
                if button.isSet {
                    self._selectedButton = button
                    changed = true
                }
            }
        } else if allowDeselect && canDeselect {
            toggleButton.isSet = false
            self._selectedButton = nil
            changed = true
        }
        return changed
    }

}
