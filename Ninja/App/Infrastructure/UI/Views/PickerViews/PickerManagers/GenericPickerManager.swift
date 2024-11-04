//
//  GenericPickerManager.swift
//  Ninja
//
//  Created by Martin Burch on 2/7/23.
//

import Foundation
import UIKit

class GenericPickerManager<ItemView: UIView, DataType>: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var values: [DataType] = []
    var setData: ((ItemView, DataType, Int) -> Void)?
    var selectRow: ((ItemView, DataType, Int) -> Void)?
    
    convenience init(values: [DataType], setData: ((ItemView, DataType, Int) -> Void)?, selectRow: ((ItemView, DataType, Int) -> Void)?) {
        self.init()
        
        self.values = values
        self.setData = setData
        self.selectRow = selectRow
    }
            
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // This is an UGLY hack to get the pickerView to behave the way our designers want. Calling this anywhere but in a "forRow" delegate method leads to an "Index out of range" exception and crash. It has to be here.
        pickerView.subviews[1].backgroundColor = .clear
        
        let valueView: ItemView = view as? ItemView ?? ItemView()
        setData?(valueView, values[row], row)
                
        return valueView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let view = pickerView.view(forRow: row, forComponent: component) as? ItemView {
            selectRow?(view, values[row], row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48
    }
}

