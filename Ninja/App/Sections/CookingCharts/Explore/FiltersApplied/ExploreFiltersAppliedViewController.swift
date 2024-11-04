//
//  ExploreFiltersAppliedViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/17/23.
//

import UIKit

class ExploreFiltersAppliedViewController: BaseViewController<ExploreFiltersAppliedView> {

    let viewModel: CookingChartsViewModel = .shared()
    let manager: ExploreManager = .shared

    lazy var toggleButtonController: ToggleButtonGroupController = ToggleButtonGroupController() { [weak self] button in
        guard let self = self else { return }
        self.subview.filtersCollectionView.reloadData()
    }
    
    override func setupViews() {
        super.setupViews()
        subview.filtersCollectionView.delegate = self
        subview.filtersCollectionView.dataSource = self

        hideBackButton = true
        subview.recipesTableView.delegate = self
        subview.recipesTableView.dataSource = self
        
        subview.resultsLabel.text = "\(self.viewModel.filteredCharts.count) Results"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func updateView() {
        tabBarController?.tabBar.isHidden = false
        self.subview.recipesTableView.reloadData()
        self.subview.recipesTableView.scrollsToTop = true
        self.subview.filtersCollectionView.reloadData()
        self.subview.resultsLabel.text = "\(self.viewModel.filteredCharts.count) Results"
    }
}

extension ExploreFiltersAppliedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.filteredCharts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreRecipeListViewTableViewCell.VIEW_ID, for: indexPath) as? ExploreRecipeListViewTableViewCell else { return UITableViewCell() }
        
    
        let filteredCharts = viewModel.filteredCharts
        
        if filteredCharts.count > 0 {
            let timeString = filteredCharts[indexPath.row].time.convertSecondsToHourMinuteStringShortStyle()
            let useGenericTemp = filteredCharts[indexPath.row].genericTemp != nil
            
            cell.titleLabel.text = filteredCharts[indexPath.row].title
            cell.headerCaption.text = filteredCharts[indexPath.row].mode.rawValue.uppercased()
            cell.recipeCookTimeLabel.text = timeString
            cell.recipeCookTempLabel.text = useGenericTemp ? filteredCharts[indexPath.row].genericTemp?.rawValue : String(filteredCharts[indexPath.row].fahrenheitTemp ?? 0) + "°F"
            
            let category = viewModel.getCategoryFromGroup(group: filteredCharts[indexPath.row].group)
            
            cell.showPorkBadge = category == .pork
            cell.showBeefBadge = category == .beef
            
            if let image = UIImage(namedCache: viewModel.filteredCharts[indexPath.row].image ?? "")?.resize(width: cell.imageView?.image?.size.width ?? 129, height: cell.imageView?.image?.size.height ?? 129) {
                cell.recipeImageView.contentMode = .scaleToFill
                cell.recipeImageView.image = image
            } else {
                cell.recipeImageView.contentMode = .scaleAspectFit
                cell.recipeImageView.image = ImageAssetLibrary.img_ninja_logo.asImage()
            }
        }

         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetails = viewModel.filteredCharts[indexPath.row]
        let vc = CookingChartPreparationViewController(chartDetails: recipeDetails)
        vc.loadViewIfNeeded()
        vc.subview.setupViewsForExplore()
        viewModel.didLoadFromPrecook = false
        self.navigationController?.pushViewController(vc, animated: true)
        subview.recipesTableView.deselectRow(at: indexPath, animated: false)
    }
    
}
extension ExploreFiltersAppliedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.filterTitlesApplied.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return manager.setFilterCollectionViewCellSize(row: indexPath.row, forFiltersApplied: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreFilterCollectionViewCell.VIEW_ID, for: indexPath) as? ExploreFilterCollectionViewCell else { return UICollectionViewCell() }
        
        guard let lineSeperatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreLineSeperatorCollectionViewCell.VIEW_ID, for: indexPath) as? ExploreLineSeperatorCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 1 {
            return lineSeperatorCell
        }
        
        cell.titleLabel.text = manager.filterTitlesApplied[indexPath.row]
        cell.imageView.isHidden = indexPath.row != 0
        cell.isAllFilters = cell.titleLabel.text == manager.filterTitlesApplied[0]
        cell.isClearFilter = cell.titleLabel.text == manager.filterTitlesApplied[manager.filterTitlesApplied.count - 1]
        
        if indexPath.row == 2 {
            cell.isFilteredApplied = viewModel.cookModeSelectedFilters.count > 0
        } else if indexPath.row == 3 {
            cell.isFilteredApplied = viewModel.cookTimeSelectedFilters.count > 0
        } else if indexPath.row == 4 {
            cell.isFilteredApplied = viewModel.foodTypeSelectedFilter.count > 0
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExploreFilterCollectionViewCell else { return }
        
        if indexPath.row == 0 {
            let vc = ExploreFilterSelectionViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        } else if indexPath.row == manager.filterTitlesApplied.count - 1 {
            self.viewModel.clearAllFilters()
            self.navigationController?.popViewController(animated: true)
        } else {
            let vc = ExploreFilterBottomSheetModalViewController()
            vc.selectedFilter = ExploreManager.FilterTitles(rawValue: cell.titleLabel.text?.lowercased() ?? "") ?? .none
            vc.modalPresentationStyle = .overCurrentContext
            vc.transitioningDelegate = self
            tabBarController?.tabBar.isHidden = true
            self.present(vc, animated: true)
        }
    }
}

extension ExploreFiltersAppliedViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        updateView()
        return nil
    }
}
