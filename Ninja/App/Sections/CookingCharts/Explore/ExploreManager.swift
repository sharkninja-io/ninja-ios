//
//  ExploreManager.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/21/23.
//

import Foundation
import UIKit

class ExploreManager {
    
    public static var _instance: ExploreManager = .init()
    
    public static var shared: ExploreManager {
        get { return _instance }
    }
 
    let filterTitlesHome = ["Filters", "", "Mode", "Time", "Food"] // empty space is for line seperator cell
    let filterTitlesApplied = ["Filters", "", "Mode", "Time", "Food", "Clear All Filters"]

    let cookTimeRanges = [Range(uncheckedBounds: (0,15)), Range(uncheckedBounds: (15,30)), Range(uncheckedBounds: (30,60)), Range(uncheckedBounds: (60,120)), Range(uncheckedBounds: (120,10000))]

    
    func setFilterCollectionViewCellSize(row: Int, forFiltersApplied: Bool) -> CGSize {
        let isAllFilters = row == 0
        let isClearFilter = row == self.filterTitlesApplied.count - 1
        let isLineSeperator = row == 1

        if isClearFilter && forFiltersApplied {
            return CGSize(width: 130, height: 32)
        } else if isAllFilters {
            return CGSize(width: 95, height: 32)
        } else if isLineSeperator {
            return CGSize(width: 2, height: 16)
        } else {
            return CGSize(width: 55, height: 32)
        }
    }
        
    func selectButtonsForFoodSelection(cell: ExploreFoodSelectorFilterTableViewCell?, viewModel: CookingChartsViewModel) {
        guard let cell = cell else { return }
        for button in cell.multiToggleController.buttonList {
            viewModel.foodTypeSelectedFilter.forEach { category in
                let categoryFromButton = FoodCategories(fromRawValue: button.label.text ?? "")
                if categoryFromButton == category {
                    cell.multiToggleController.selectedButtonIdentifiers.append(button.label.text)
                    if cell.multiToggleController.isSelected(button) {
                        button.isSet = true
                    }
                }
            }
        }
    }
    
    func selectButtonsForModeSelection(cell: ExploreCookModeFilterTableViewCell?, viewModel: CookingChartsViewModel) {
        guard let cell = cell else { return }
        for button in cell.multiToggleController.buttonList {
            viewModel.cookModeSelectedFilters.forEach {
                if button.label.text?.lowercased() == $0.lowercased() {
                    cell.multiToggleController.selectedButtonIdentifiers.append(button.label.text)
                    if cell.multiToggleController.isSelected(button) {
                        button.isSet = true
                    }
                }
            }
        }
    }
    
    func disableButtonsForModeSelection(cell: ExploreCookModeFilterTableViewCell?, modes: [CookMode]) {
        guard let cell = cell else { return }
        for button in cell.multiToggleController.buttonList {
            for mode in modes {
                if button.label.text == String(describing: mode) {
                    button.isEnabled = false
                }
            }
        }
    }
    
    func setApplyButtonAttributes(viewModel: CookingChartsViewModel, button: UIButton, isBottomSheet: Bool) {
        if isBottomSheet {
            if viewModel.filteredCharts.count == 0 {
                button.setTitle("0 RESULTS", for: .normal)
                button.isEnabled = false
            } else  {
                button.setTitle("APPLY", for: .normal)
                button.isEnabled = true
            }
        } else {
            if viewModel.filteredCharts.count > 0 {
                button.setTitle("VIEW \(viewModel.filteredCharts.count) RESULTS", for: .normal)
                button.isEnabled = true
            } else {
                button.setTitle("0 RESULTS", for: .normal)
                button.isEnabled = false
            }
        }
    }
    
    func addSelectedCookModesToFilterList(viewModel: CookingChartsViewModel, toggle: BaseToggleButton) {
        let mode = toggle.label.text ?? ""
    
        if toggle.isSet {
            if !viewModel.cookModeSelectedFilters.contains(mode) {
                viewModel.cookModeSelectedFilters.append(mode)
            }
        } else {
            if let index = viewModel.cookModeSelectedFilters.firstIndex(of: mode) {
                viewModel.cookModeSelectedFilters.remove(at: index)
            }
        }
    }
    
    func addSelectedFoodModesToFilterList(viewModel: CookingChartsViewModel, toggle: BaseToggleButton, category: FoodCategories) {
        if toggle.isSet {
            viewModel.foodTypeSelectedFilter.append(category)
        } else {
            if let index = viewModel.foodTypeSelectedFilter.firstIndex(of: category) {
                viewModel.foodTypeSelectedFilter.remove(at: index)
            }
        }
    }
    
    func addSelectedTimesToFilterList(viewModel: CookingChartsViewModel, box: Checkbox, index: Int) {
        if box.isChecked {
            viewModel.cookTimeSelectedFilters.append(self.cookTimeRanges[index])
        } else {
            if let index = viewModel.cookTimeSelectedFilters.firstIndex(of: self.cookTimeRanges[index]) {
                viewModel.cookTimeSelectedFilters.remove(at: index)
            }
        }
    }
    
    enum FilterTitles: String {
        case cooktime = "time"
        case cookmode = "mode"
        case foodselector = "food"
        case none = ""
        
        init(fromRawValue: String) {
            self = FilterTitles(rawValue: fromRawValue) ?? .none
        }
    }
}
