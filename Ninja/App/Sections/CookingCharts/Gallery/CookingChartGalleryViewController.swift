//
//  CookingChartGalleryViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/30/23.
//

import UIKit

class CookingChartGalleryViewController: BaseViewController<CookingChartGalleryView> {

    var viewModel: CookingChartsViewModel = .shared()

    lazy var toggleButtonController: ToggleButtonGroupController = ToggleButtonGroupController() { [weak self] button in
        guard let self = self else { return }
        self.viewModel.selectedFoodCategory = FoodCategories(rawValue: button?.label.text ?? "") ?? FoodCategories.beef
        self.subview.foodCollectionView.reloadData()
    }
    
    override func setupViews() {
        super.setupViews()
        subview.foodCategorySelectionTableView.delegate = self
        subview.foodCategorySelectionTableView.dataSource = self
        subview.foodCollectionView.delegate = self
        subview.foodCollectionView.dataSource = self
        
        let modeString = viewModel.selectedCookModeType == .AirCrisp ? "Air Crisp" : String(describing: viewModel.selectedCookModeType)
        subview.titleLabel.text = "What are you thinking to \(modeString) today?"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for index in subview.foodCollectionView.indexPathsForSelectedItems ?? [] {
            subview.foodCollectionView.deselectItem(at: index, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: IconAssetLibrary.system_xmark.asSystemImage()?.resize(multiplier: 0.85), style: .plain, target: self, action: #selector(xmarkTapped))
    }
}


extension CookingChartGalleryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displaySubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: CookItem = viewModel.displaySubject.value[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.cell.VIEW_ID, for: indexPath) as? FoodModeSelectionViewCell else { return UITableViewCell() }
        
        cell.foodOptionList = viewModel.validFoodCategories
        cell.multiToggleController.allowSingleSelection = true
        cell.multiToggleController.onSelectCallback = { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.selectedFoodCategory = FoodCategories(rawValue: cell.multiToggleController.selectedButton?.label.text ?? "" ) ?? FoodCategories.beef
            self.subview.foodCollectionView.reloadData()
        }
        
        cell.collectionView.layoutIfNeeded()
        if let selectedCell = cell.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? SelectionItemViewCell {
            _ = cell.multiToggleController.selectButton(selectedCell.button)
            self.viewModel.selectedFoodCategory = FoodCategories(rawValue: cell.multiToggleController.selectedButton?.label.text ?? "" ) ?? FoodCategories.beef
            self.subview.foodCollectionView.reloadData()
        }
        return cell
    }
}

extension CookingChartGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.galleryCharts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHomeGridCollectionViewCell.VIEW_ID, for: indexPath) as? ExploreHomeGridCollectionViewCell else { return UICollectionViewCell() }
        
        cell.titleLabel.text = viewModel.galleryCharts[indexPath.row].title
        cell.headerCaption.text = viewModel.galleryCharts[indexPath.row].mode.rawValue.uppercased()
        if let image = UIImage(namedCache: viewModel.galleryCharts[indexPath.row].image ?? "")?.resize(width: cell.imageView.image?.size.width ?? 175, height: cell.imageView.image?.size.height ?? 96) {
            cell.imageView.contentMode = .scaleToFill
            cell.imageView.image = image
        } else {
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.image = ImageAssetLibrary.img_ninja_logo.asImage()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true
        }
        let recipeDetails = viewModel.galleryCharts[indexPath.row]

        let vc = CookingChartPreparationViewController(chartDetails: recipeDetails)
        vc.loadViewIfNeeded()
        vc.setupViewsForPrecook()
        viewModel.didLoadFromPrecook = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CookingChartGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 8, height: 160)
    }
}

extension CookingChartGalleryViewController {
    @objc func xmarkTapped() {
        dismiss(animated: true)
    }
}


extension CookingChartGalleryViewController {
    private func parseTitleString(title: String) -> String {
        
        let strs = title.components(separatedBy: " ")
        if strs.count >= 3 {
            return strs[0] + " " + strs[1]
        } else {
            return strs[0]
        }
    }
}
