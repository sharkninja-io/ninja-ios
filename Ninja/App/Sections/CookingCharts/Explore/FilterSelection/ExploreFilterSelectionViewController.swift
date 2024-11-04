//
//  ExploreFilterSelectionViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/15/23.
//

import UIKit


class ExploreFilterSelectionViewController: BaseViewController<ExploreFilterSelectionView> {
    
    let viewModel: CookingChartsViewModel = .shared()
    let manager: ExploreManager = .shared
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func setupViews() {
        super.setupViews()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.applyButton.onEvent { [weak self] _ in
            self?.dismiss(animated: true)
        }
        subview.closeButton.onEvent { [weak self] _ in
            self?.dismiss()
        }
        
        viewModel.previousCookTimeFilters = viewModel.cookTimeSelectedFilters
        viewModel.previousCookModeFilters = viewModel.cookModeSelectedFilters
        viewModel.previousFoodTypeFilters = viewModel.foodTypeSelectedFilter
        
        manager.setApplyButtonAttributes(viewModel: self.viewModel, button: subview.applyButton, isBottomSheet: false)
    }
    
    private func dismiss() {
        viewModel.cookTimeSelectedFilters = viewModel.previousCookTimeFilters
        viewModel.cookModeSelectedFilters = viewModel.previousCookModeFilters
        viewModel.foodTypeSelectedFilter = viewModel.previousFoodTypeFilters
        self.viewModel.filterChartsForExplore()
        self.dismiss(animated: true)
    }
}

extension ExploreFilterSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 150 : 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreCookTimeFilterTableViewCell.VIEW_ID, for: indexPath) as? ExploreCookTimeFilterTableViewCell else { return UITableViewCell() }
            
            checkSelectedTimes(cell: cell)
            checkBoxOnEvent(box: cell.lessThanFifteenMinutesCheckBox, index: 0)
            checkBoxOnEvent(box: cell.fifteenToThirtyMinutesCheckBox, index: 1)
            checkBoxOnEvent(box: cell.thirtyToSixtyMinutesCheckBox, index: 2)
            checkBoxOnEvent(box: cell.sixtyToOneTwentyMinutesCheckBox, index: 3)
            checkBoxOnEvent(box: cell.oneTwentyMinutesPlusCheckBox, index: 4)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreCookModeFilterTableViewCell.VIEW_ID, for: indexPath) as? ExploreCookModeFilterTableViewCell else { return UITableViewCell() }

            cell.multiToggleController.onSelectCallback = { [weak self] toggle in
                guard let self = self, let toggle = toggle else { return }
                
                self.manager.addSelectedCookModesToFilterList(viewModel: self.viewModel, toggle: toggle)
                self.viewModel.filterChartsForExplore()
                self.manager.setApplyButtonAttributes(viewModel: self.viewModel, button: self.subview.applyButton, isBottomSheet: false)
            }
            
            cell.multiToggleController.onRefreshCallback = { [weak self] _ in
                guard let self = self else { return }
                self.manager.selectButtonsForModeSelection(cell: cell, viewModel: self.viewModel)
                self.manager.disableButtonsForModeSelection(cell: cell, modes: [.Bake, .Broil, .Roast])
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreFoodSelectorFilterTableViewCell.VIEW_ID, for: indexPath) as? ExploreFoodSelectorFilterTableViewCell else { return UITableViewCell() }
            cell.foodOptionList = self.viewModel.getFoodCategoriesWithIcons()
            
            cell.multiToggleController.onSelectCallback = { [weak self] toggle in
                guard let self = self, let toggle = toggle else { return }
                let foodCategory = FoodCategories(fromRawValue: cell.multiToggleController.selectedButton?.label.text ?? .emptyOrNone)
                
                self.manager.addSelectedFoodModesToFilterList(viewModel: self.viewModel, toggle: toggle, category: foodCategory)
                self.viewModel.filterChartsForExplore()
                self.manager.setApplyButtonAttributes(viewModel: self.viewModel, button: self.subview.applyButton, isBottomSheet: false)
            }
            
            cell.multiToggleController.onRefreshCallback = { [weak self] _ in
                guard let self = self else { return }
                self.manager.selectButtonsForFoodSelection(cell: cell, viewModel: self.viewModel)
            }
            
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ExploreFilterSelectionViewController {
    
    func checkSelectedTimes(cell: ExploreCookTimeFilterTableViewCell) {
        cell.lessThanFifteenMinutesCheckBox.isChecked = self.viewModel.cookTimeSelectedFilters.contains(manager.cookTimeRanges[0])
        cell.fifteenToThirtyMinutesCheckBox.isChecked = self.viewModel.cookTimeSelectedFilters.contains(manager.cookTimeRanges[1])
        cell.thirtyToSixtyMinutesCheckBox.isChecked = self.viewModel.cookTimeSelectedFilters.contains(manager.cookTimeRanges[2])
        cell.sixtyToOneTwentyMinutesCheckBox.isChecked = self.viewModel.cookTimeSelectedFilters.contains(manager.cookTimeRanges[3])
        cell.oneTwentyMinutesPlusCheckBox.isChecked = self.viewModel.cookTimeSelectedFilters.contains(manager.cookTimeRanges[4])
    }
    
    func checkBoxOnEvent(box: Checkbox, index: Int) {
        box.onEvent { [weak self] _ in
            guard let self = self else { return }
            self.manager.addSelectedTimesToFilterList(viewModel: self.viewModel, box: box, index: index)
            self.viewModel.filterChartsForExplore()
            self.manager.setApplyButtonAttributes(viewModel: self.viewModel, button: self.subview.applyButton, isBottomSheet: false)
        }
    }
}
