//
//  ExploreViewController.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/25/22.
//

import UIKit

class ExploreHomeViewController: BaseViewController<ExploreHomeView> {
    
    let viewModel: CookingChartsViewModel = .shared()
    let manager: ExploreManager = .shared

    override func setupViews() {
        super.setupViews()
        subview.filtersCollectionView.delegate = self
        subview.filtersCollectionView.dataSource = self
        subview.recipesCollectionView.delegate = self
        subview.recipesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.hasActiveFilters {
            self.navigationController?.pushViewController(ExploreFiltersAppliedViewController(), animated: false)
        }

        for index in subview.recipesCollectionView.indexPathsForSelectedItems ?? [] {
            subview.recipesCollectionView.deselectItem(at: index, animated: true)
        }
        
        subview.filtersCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        
        if viewModel.navigateToCook {
            viewModel.navigateToCook = false
            tabBarController?.selectedIndex = 1
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension ExploreHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subview.filtersCollectionView {
            return manager.filterTitlesHome.count
        } else if collectionView == subview.recipesCollectionView {
            return viewModel.charts.count
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subview.filtersCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreFilterCollectionViewCell.VIEW_ID, for: indexPath) as? ExploreFilterCollectionViewCell else { return UICollectionViewCell() }
            
            guard let lineSeperatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreLineSeperatorCollectionViewCell.VIEW_ID, for: indexPath) as? ExploreLineSeperatorCollectionViewCell else { return UICollectionViewCell() }
            
            if indexPath.row == 1 {
                return lineSeperatorCell
            }
            cell.titleLabel.text = manager.filterTitlesHome[indexPath.row]
            cell.imageView.isHidden = indexPath.row != 0
            cell.isAllFilters = indexPath.row == 0 

            return cell
        } else if collectionView == subview.recipesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHomeGridCollectionViewCell.VIEW_ID, for: indexPath) as? ExploreHomeGridCollectionViewCell else { return UICollectionViewCell() }

            cell.titleLabel.text = viewModel.charts[indexPath.row].title
            cell.headerCaption.text = viewModel.charts[indexPath.row].mode.rawValue.uppercased()
            
            if let image = UIImage(namedCache: viewModel.charts[indexPath.row].image ?? "")?.resize(width: cell.imageView.image?.size.width ?? 147, height: cell.imageView.image?.size.height ?? 96) {
                cell.imageView.contentMode = .scaleToFill
                cell.imageView.image = image
            } else {
                cell.imageView.contentMode = .scaleAspectFit
                cell.imageView.image = ImageAssetLibrary.img_ninja_logo.asImage()
            }

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subview.filtersCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ExploreFilterCollectionViewCell else { return }
            
            if indexPath.row == 0 {
                let vc = ExploreFilterSelectionViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            } else {
                let vc = ExploreFilterBottomSheetModalViewController()
                vc.selectedFilter = ExploreManager.FilterTitles(rawValue: cell.titleLabel.text?.lowercased() ?? "") ?? .none
                vc.modalPresentationStyle = .overCurrentContext
                vc.transitioningDelegate = self
                tabBarController?.tabBar.isHidden = true
                self.present(vc, animated: true)
            }
        } else {
            let recipeDetails = viewModel.charts[indexPath.row]
            let vc = CookingChartPreparationViewController(chartDetails: recipeDetails)
            vc.loadViewIfNeeded()
            vc.subview.setupViewsForExplore()
            viewModel.didLoadFromPrecook = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ExploreHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == subview.recipesCollectionView {
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
            return CGSize(width: widthPerItem - 8, height: 160)
        } else {
            return manager.setFilterCollectionViewCellSize(row: indexPath.row, forFiltersApplied: false)
        }
    }
}

extension ExploreHomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if viewModel.hasActiveFilters {
            tabBarController?.tabBar.isHidden = false
            self.navigationController?.pushViewController(ExploreFiltersAppliedViewController(), animated: true)
        }
        return nil
    }
}
