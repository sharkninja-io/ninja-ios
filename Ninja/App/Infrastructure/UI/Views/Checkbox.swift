//
//  Checkbox.swift
//  Ninja
//
//  Created by Martin Burch on 9/15/22.
//

import UIKit

@IBDesignable
// NOTE: Set buttonType as .custome in XIBs
class Checkbox: UIButton {
    
    var checkedImage: UIImage? = IconAssetLibrary.system_checkbox_checked.asSystemImage() {
        didSet {
            updateState()
        }
    }
    var unCheckedImage: UIImage? = IconAssetLibrary.system_checkbox_unchecked.asSystemImage() {
        didSet {
            updateState()
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            updateState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        updateState()
        
        self.onEvent { [weak self] checkbox in
            guard let self = self else { return }
            self.isChecked = !self.isChecked
        }
    }
    
    private func updateState() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.setImage(self.isChecked ? self.checkedImage : self.unCheckedImage, for: .normal)
        }
    }
}
