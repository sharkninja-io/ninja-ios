//
//  CookingChartPreparationViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/30/23.
//

import UIKit
import GrillCore

class CookingChartPreparationViewController: BaseViewController<CookingChartPreparationView> {
    
    let viewModel: CookingChartsViewModel = .shared()
    var chartDetails: CookingCharts
        
    init(chartDetails: CookingCharts) {
        self.chartDetails = chartDetails
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupViews() {
        super.setupViews()
        subview.populate(with: chartDetails)
        subview.startCookingButton.onEvent { [weak self] control in
            self?.didTapStartCookingButton(control)
        }
    }
    
    func didTapStartCookingButton(_ sender: UIControl) {
        viewModel.selectedCookModeType = viewModel.getCookModeFromMode(mode: chartDetails.mode)
        
        let duration = viewModel.selectedCookModeType == .Broil ? chartDetails.time : chartDetails.time / 60
        let smoke = viewModel.selectedCookModeType == .Smoke // TODO: is smoke an option in the charts ???
        if let temp = chartDetails.fahrenheitTemp {
            viewModel.startCooking(cookMode: viewModel.selectedCookModeType, temp: temp, duration: duration, infuse: smoke)
        } else {
            
            let genericTemp = chartDetails.genericTemp
            var intValue = 0
            
            switch genericTemp {
            case .lo:
                intValue = 1
            case .med:
                intValue = 2
            case .hi:
                intValue = 3
            case .none:
                break
            }
            viewModel.startCooking(cookMode: viewModel.selectedCookModeType, temp: intValue, duration: duration, infuse: smoke)
        }
        if !viewModel.didLoadFromPrecook {
            viewModel.navigateToCook = true
        }
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.presentingViewController?.dismiss(animated: true)
    }
    
    func setupViewsForPrecook() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: IconAssetLibrary.system_xmark.asSystemImage()?.resize(multiplier: 0.85), style: .plain, target: self, action: #selector(xmarkTapped))
    }
    
    @objc func xmarkTapped() {
        dismiss(animated: true)
    }
}
