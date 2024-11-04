//
//  ExploreFilterBottomSheetModalViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/16/23.
//

import UIKit

class ExploreFilterBottomSheetModalViewController: BaseViewController<ExploreFilterBottomSheetModalView>, UIGestureRecognizerDelegate {
     
    let viewModel: CookingChartsViewModel = .shared()
    let manager: ExploreManager = .shared
    var selectedFilter: ExploreManager.FilterTitles = .none
    
    override func setupViews() {
        super.setupViews()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
                
        subview.modalView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragToDismissGesture(_:))))
        subview.tapToDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismissAction)))
        
        subview.applyButton.onEvent { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        viewModel.previousCookTimeFilters = viewModel.cookTimeSelectedFilters
        viewModel.previousCookModeFilters = viewModel.cookModeSelectedFilters
        viewModel.previousFoodTypeFilters = viewModel.foodTypeSelectedFilter
        manager.setApplyButtonAttributes(viewModel: self.viewModel, button: subview.applyButton, isBottomSheet: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cell = subview.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        manager.selectButtonsForFoodSelection(cell: cell as? ExploreFoodSelectorFilterTableViewCell, viewModel: viewModel)
        manager.selectButtonsForModeSelection(cell: cell as? ExploreCookModeFilterTableViewCell , viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.35
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1.0
    }
    
    private func dismiss() {
        viewModel.cookTimeSelectedFilters = viewModel.previousCookTimeFilters
        viewModel.cookModeSelectedFilters = viewModel.previousCookModeFilters
        viewModel.foodTypeSelectedFilter = viewModel.previousFoodTypeFilters
        self.viewModel.filterChartsForExplore()
        self.dismiss(animated: true)
    }
}

extension ExploreFilterBottomSheetModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedFilter {
            case .cooktime:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreCookTimeFilterTableViewCell.VIEW_ID, for: indexPath) as? ExploreCookTimeFilterTableViewCell else { return UITableViewCell() }
            subview.modalHeightAnchor.constant = 300.0

                cell.selectionStyle = .none
            
                checkSelectedTimes(cell: cell)

                checkBoxOnEvent(box: cell.lessThanFifteenMinutesCheckBox, index: 0)
                checkBoxOnEvent(box: cell.fifteenToThirtyMinutesCheckBox, index: 1)
                checkBoxOnEvent(box: cell.thirtyToSixtyMinutesCheckBox, index: 2)
                checkBoxOnEvent(box: cell.sixtyToOneTwentyMinutesCheckBox, index: 3)
                checkBoxOnEvent(box: cell.oneTwentyMinutesPlusCheckBox, index: 4)

                return cell
            case .cookmode:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreCookModeFilterTableViewCell.VIEW_ID, for: indexPath) as? ExploreCookModeFilterTableViewCell else { return UITableViewCell() }
            subview.modalHeightAnchor.constant = 300.0

                cell.selectionStyle = .none

                cell.multiToggleController.onSelectCallback = { [weak self] toggle in
                    guard let self = self, let toggle = toggle else { return }
                    self.manager.addSelectedCookModesToFilterList(viewModel: self.viewModel, toggle: toggle)
                    self.viewModel.filterChartsForExplore()
                    self.manager.setApplyButtonAttributes(viewModel: self.viewModel, button: self.subview.applyButton, isBottomSheet: true)
                }
            
            cell.multiToggleController.onRefreshCallback = { [weak self] _ in
                guard let self = self else { return }
                self.manager.selectButtonsForModeSelection(cell: cell, viewModel: self.viewModel)
                self.manager.disableButtonsForModeSelection(cell: cell, modes: [.Bake, .Broil, .Roast])

            }
                return cell
            case .foodselector:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreFoodSelectorFilterTableViewCell.VIEW_ID, for: indexPath) as? ExploreFoodSelectorFilterTableViewCell else { return UITableViewCell() }
            
                cell.foodOptionList = self.viewModel.getFoodCategoriesWithIcons()
                cell.selectionStyle = .none
                subview.modalHeightAnchor.constant = 320.0
            
                cell.multiToggleController.onSelectCallback = { [weak self] toggle in
                    guard let self = self, let toggle = toggle else { return }
                    let foodCategory = FoodCategories(fromRawValue: cell.multiToggleController.selectedButton?.label.text ?? .emptyOrNone)

                    self.manager.addSelectedFoodModesToFilterList(viewModel: self.viewModel, toggle: toggle, category: foodCategory)
                    self.viewModel.filterChartsForExplore()
                    self.manager.setApplyButtonAttributes(viewModel: self.viewModel, button: self.subview.applyButton, isBottomSheet: true)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ExploreFilterBottomSheetModalViewController {
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
            self.manager.setApplyButtonAttributes(viewModel: self.viewModel, button: self.subview.applyButton, isBottomSheet: true)
        }
    }
}

extension ExploreFilterBottomSheetModalViewController {
    
    @objc private func tapToDismissAction() {
        dismiss()
    }
    
    //https://stackoverflow.com/questions/29290313/in-ios-how-to-drag-down-to-dismiss-a-modal
    @objc func dragToDismissGesture(_ sender:UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        let translation = sender.translation(in: view)
    
        let newY = ensureRange(value: view.frame.minY + translation.y, minimum: 0, maximum: view.frame.maxY)
        let progress = progressAlongAxis(newY, view.bounds.width)
    
        view.frame.origin.y = newY
    
        if sender.state == .ended {
            let velocity = sender.velocity(in: view)
           if velocity.y >= 300 || progress > percentThreshold {
                dismiss()
           } else {
               UIView.animate(withDuration: 0.2, animations: {
                   self.view.frame.origin.y = 0
               })
          }
       }
    
       sender.setTranslation(.zero, in: view)
    }
    
    func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
            let movementOnAxis = pointOnAxis / axisLength
            let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        }
        
    func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
        return min(max(value, minimum), maximum)
    }
}
