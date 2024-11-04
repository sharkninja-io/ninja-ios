//
//  ApplianceLandingViewController.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 9/27/22.
//

import UIKit

class ApplianceLandingViewController: BaseViewController<AppliancesLandingView> {
    
    private let viewModel: SettingsViewModel = .shared()
    
    private var grillList: [Grill] = [] {
        didSet {
            self.subview.appliancesPresent = !grillList.isEmpty
            self.subview.collectionView.reloadData()
        }
    }
        
    override func loadView() {
        super.loadView()
    }
    
    override func setupViews() {
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
        
        subview.collectionView.delegate = self
        subview.collectionView.dataSource = self
        
        subview.addApplianceButton.onEvent() { [weak self] _ in
            guard let self else { return }
            self.toPairing()
        }
        
        // Try to use prefetched data to avoid issues with slow loading speeds
        grillList = SettingsViewModel.shared().currentGrillList
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.grillsSubject.receive(on: DispatchQueue.main).sink { [weak self] grills in
            guard let self else { return }
            self.grillList = grills ?? []
        }.store(in: &disposables)
    }
    
    func toPairing() {
        let vc = UINavigationController(rootViewController: BTPermissionsViewController())
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
}

extension ApplianceLandingViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: false)
        return nil
    }
}

extension ApplianceLandingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grillList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApplianceCollectionViewCell.VIEW_ID, for: indexPath) as! ApplianceCollectionViewCell
        let grill = grillList[indexPath.row]
        cell.connectData(grill)
        return cell
    }
}

extension ApplianceLandingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let grill = grillList[indexPath.row]
        viewModel.setCurrentGrill(grill)
        let vc = ApplianceSettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ApplianceLandingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = subview.window?.windowScene?.screen.bounds.width ?? 390
        return CGSize(width: screenWidth, height: 180)
    }
}
