//
//  ProteinSelectionViewCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/18/23.
//

import UIKit

class ProteinSelectionItem {
    var foodType: Food
    var title: String
    var icon: UIImage?
    
    init(_ foodType: Food, title: String, icon: UIImage?) {
        self.foodType = foodType
        self.title = title
        self.icon = icon
    }
}

class ProteinSelectionViewCell: CookSelectionViewCell {
    
    var selectorItem: CookCellItem<Food>?

    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        disposables.removeAll()
        
        if let selectorItem = data as? CookCellItem<Food> {
            self.selectorItem = selectorItem
            selectorItem.availableValuesSubject.receive(on: DispatchQueue.main).sink { modes in
                // TODO: // - filter food???
            }.store(in: &disposables)
            selectorItem.currentValueSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] food in
                let newFood = (food == .NotSet) ? .Manual : food
                let index = (self?.itemList as? [ProteinSelectionItem])?.firstIndex(where: { $0.foodType == newFood })
                if let index = index {
                    self?.selectedIndex = index
                }
            }.store(in: &disposables)
            toggleController.onSelectCallback = { button in
                let identifier = button?.identifier as? Food ?? .Manual
                selectorItem.currentValueSubject.send(identifier)
            }
        }
    }
    
    func saveValue() {
        let value = toggleController.selectedButton?.identifier as? Food ?? .Manual
        selectorItem?.storeValueSubject.send(value)
    }
    
    var proteinList: [ProteinSelectionItem] = [
        .init(.Chicken, title: CookDisplayValues.getFoodDisplayName(food: .Chicken), icon: IconAssetLibrary.ico_poultry.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        .init(.Beef, title: CookDisplayValues.getFoodDisplayName(food: .Beef), icon: IconAssetLibrary.ico_beef.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        .init(.Pork, title: CookDisplayValues.getFoodDisplayName(food: .Pork), icon: IconAssetLibrary.ico_pork.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        .init(.Fish, title: CookDisplayValues.getFoodDisplayName(food: .Fish), icon: IconAssetLibrary.ico_fish.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
    ]
    
    var proteinExtraList: [ProteinSelectionItem] = [
        .init(.Manual, title: CookDisplayValues.getFoodDisplayName(food: .Manual), icon: IconAssetLibrary.ico_thermometer.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
    ]
    
    override func setupViews() {
        super.setupViews()
        
        // TODO: - saved to be able to undo until confirmed
//        toggleController.allowDeselect = true
//        
//        itemList = proteinList
        toggleController.allowDeselect = false
        
        itemList = proteinExtraList + proteinList
    }
    
    override func setDataToCell(item: Any, cell: SelectionItemViewCell) {
        if let item = item as? ProteinSelectionItem {
            cell.setData(title: item.title, icon: item.icon, identifier: item.foodType)
        }
    }
}
