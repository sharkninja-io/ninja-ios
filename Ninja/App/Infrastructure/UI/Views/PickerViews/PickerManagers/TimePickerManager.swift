//
//  TimePickerManager.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/17/23.
//

import Foundation
import UIKit

class TimePickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    var selectTime: ((Int) -> Void)?

    convenience init(selectTime: ((Int) -> Void)?) {
        self.init()
        self.selectTime = selectTime
    }
    
    var values: [UInt32] = [] {
        didSet {
            firstPickerValues = values.map({ Int($0 / 60) }).unique()
            refreshSecondRow()
        }
    }
    var firstPickerValues = [Int](0...8)    // can be hours or minutes depending on cook type
    var secondPickerValues = [Int](0..<60)  // can be minutes or secounds depending on cook type
    
    var selectedFirstRow: Int = 0 {
        didSet {
            refreshSecondRow()
        }
    }
    var selectedSecondRow: Int = 0
    
    func refreshSecondRow() {
        let hours = (selectedFirstRow < firstPickerValues.count) ? firstPickerValues[selectedFirstRow] : (firstPickerValues.first ?? 0)
        secondPickerValues = values.filter({
            $0 >= (hours * 60) && $0 < (hours + 1) * 60
        }).map({ Int($0 % 60) }).unique()
        if selectedSecondRow >= secondPickerValues.count {
            selectedSecondRow = 0
        }
    }
    
    var rowHeight: CGFloat = 48.0 // row height for picker
    
    private func getFirstPickerString(value: Int) -> String {
        return "\(value)"
    }
    
    private func getSecondPickerString(value: Int) -> String {
        return String("00\(value)".suffix(2))
    }
    
    func getTime() -> Int {
        guard selectedFirstRow < firstPickerValues.count, selectedSecondRow < secondPickerValues.count else { return 0 }
        
        return firstPickerValues[selectedFirstRow] * 60 + secondPickerValues[selectedSecondRow]
    }
    
    func getRowOfFirst(value: Int) -> Int {
        return firstPickerValues.firstIndex(of: value) ?? 0
    }

    func getRowOfSecond(value: Int) -> Int {
        return secondPickerValues.firstIndex(of: value) ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return firstPickerValues.count
        } else {
            return secondPickerValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // This is an UGLY hack to get the pickerView to behave the way our designers want. Calling this anywhere but in a "forRow" delegate method leads to an "Index out of range" exception and crash. It has to be here.
        pickerView.subviews[1].backgroundColor = .clear
        
        let label: UILabel = view as? UILabel ?? UILabel()
        label.text = (component == 0) ? getFirstPickerString(value: firstPickerValues[safe: row] ?? 0) : getSecondPickerString(value: secondPickerValues[safe: row] ?? 0)
        let isSelected = (component == 0) ? selectedFirstRow == row : selectedSecondRow == row // pickerView.selectedRow(inComponent: component) == row
        label.setStyle(isSelected ? .cookPickerLargeLabel : .cookPickerSmallLabel, theme: theme())
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  component == 0 {
            selectedFirstRow = row
        } else {
            selectedSecondRow = row
        }
        self.selectTime?(getTime())
        
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
}
