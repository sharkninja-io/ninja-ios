//
//  ModeSelectionViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/29/22.
//
import UIKit

class CookModeSelectionItem {
    var cookMode: CookMode
    var title: String
    var icon: UIImage?
    
    init(_ cookMode: CookMode, title: String, icon: UIImage?) {
        self.cookMode = cookMode
        self.title = title
        self.icon = icon
    }
}

class ModeSelectionViewCell: CookSelectionViewCell {
    
    var selectorItem: CookCellItem<CookMode>?
    var disabledItems: [CookMode] = []

    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        disposables.removeAll()
        
        if let selectorItem = data as? CookCellItem<CookMode> {
            self.selectorItem = selectorItem
            selectorItem.availableValuesSubject.receive(on: DispatchQueue.main).sink { modes in
                // TODO: // - filter modes???
            }.store(in: &disposables)
            selectorItem.currentValueSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] mode in
                let index = self?.modeList.firstIndex { $0.cookMode == mode }
                if let index = index {
                    self?.selectedIndex = index
                }
            }.store(in: &disposables)
            selectorItem.extrasSubject.receive(on: DispatchQueue.main).sink { [weak self] cookType in
                self?.setDisabledItems(cookType: cookType as? CookType)
            }.store(in: &disposables)
            toggleController.onSelectCallback = { button in
                if let identifier = button?.identifier as? CookMode {
                    selectorItem.currentValueSubject.send(identifier)
                }
            }
        }
    }
    
    func saveValue() {
        let value = toggleController.selectedButton?.identifier as? CookMode ?? .Unknown
        selectorItem?.storeValueSubject.send(value)
    }
    
    var modeList: [CookModeSelectionItem] = [
        CookModeSelectionItem(.Grill, title: CookDisplayValues.getModeDisplayName(cookMode: .Grill), icon: IconAssetLibrary.ico_mode_grill.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        CookModeSelectionItem(.Smoke, title: CookDisplayValues.getModeDisplayName(cookMode: .Smoke), icon: IconAssetLibrary.ico_mode_smoke.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        CookModeSelectionItem(.AirCrisp, title: CookDisplayValues.getModeDisplayName(cookMode: .AirCrisp), icon: IconAssetLibrary.ico_mode_air_crisp.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        CookModeSelectionItem(.Roast, title: CookDisplayValues.getModeDisplayName(cookMode: .Roast), icon: IconAssetLibrary.ico_mode_roast.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        CookModeSelectionItem(.Bake, title: CookDisplayValues.getModeDisplayName(cookMode: .Bake), icon: IconAssetLibrary.ico_mode_bake.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        CookModeSelectionItem(.Broil, title: CookDisplayValues.getModeDisplayName(cookMode: .Broil), icon: IconAssetLibrary.ico_mode_broil.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)),
        CookModeSelectionItem(.Dehydrate, title: CookDisplayValues.getModeDisplayName(cookMode: .Dehydrate), icon: IconAssetLibrary.ico_mode_dehydrate.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02))
    ]
    
    override func setupViews() {
        super.setupViews()
        
        itemList = modeList
    }
    
    func setDisabledItems(cookType: CookType?) {
        switch cookType {
        case .Timed:
            disabledItems = []
        default:
            disabledItems = CookDisplayValues.disabledThermometerCookModes
        }
    }
    
    override func setDataToCell(item: Any, cell: SelectionItemViewCell) {
        if let item = item as? CookModeSelectionItem {
            cell.setData(title: item.title, icon: item.icon, identifier: item.cookMode)
            cell.button.isEnabled = !disabledItems.contains(item.cookMode)
        }
    }
}
