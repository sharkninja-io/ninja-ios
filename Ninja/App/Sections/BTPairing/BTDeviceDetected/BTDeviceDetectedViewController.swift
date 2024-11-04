//
//  BTDeviceDetectedViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/28/22.
//

import UIKit
import CoreBluetooth

class BTDeviceDetectedViewController: BTPairingBaseViewController<BTDeviceDetectedView> {
    
    var pairableGrills: [BTJoinableGrill] = []
    
    override func setupViews() {
        super.setupViews()
        
        subview.collectionView.delegate = self
        subview.collectionView.dataSource = self
        
        subview.continueButton.onEvent{ [weak self] _ in self?.toConnectingScreen() }
        subview.continueButton.isEnabled = false
        Logger.Debug("BT_PAIRING: DETECTING DEVICE...")
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.pairableGrillsSubject.receive(on: DispatchQueue.main).sink { [weak self] pairableGrills in
            Logger.Debug("BT_PAIRING: DETECTING DEVICE: \(pairableGrills.count)")
           if self?.pairableGrills.map({ $0.uuid }) != pairableGrills.map({ $0.uuid }) {
                self?.pairableGrills = pairableGrills
                self?.subview.collectionView.reloadData()
            }
        }.store(in: &disposables)
        viewModel.selectedBluetoothUUIDSubject.receive(on: DispatchQueue.main).sink { [weak self] uuid in
            Logger.Debug("BT_PAIRING: DEVICE SELECTED: \(uuid ?? "nil")")
            self?.subview.collectionView.reloadData()
            if uuid != nil {
                self?.subview.continueButton.isEnabled = true
            }
        }.store(in: &disposables)
    }
    
    func toConnectingScreen() {
        navigationController?.pushViewController(BTConnectingLoadingViewController(), animated: true)
    }
}

extension BTDeviceDetectedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pairableGrills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BTApplianceCollectionViewCell.VIEW_ID, for: indexPath)
        if indexPath.row < pairableGrills.count {
            let pairableGrill = pairableGrills[indexPath.row]
            if let deviceCell = (cell as? BTApplianceCollectionViewCell) {
                deviceCell.macAddress = pairableGrill.mac
                deviceCell.uuid = pairableGrill.uuid
                if pairableGrill.uuid == viewModel.selectedBluetoothUUIDSubject.value {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
                }
            }
        }
        return cell
    }
}

extension BTDeviceDetectedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let uuid = (cell as? BTApplianceCollectionViewCell)?.uuid
        if let uuid = uuid {
            viewModel.selectedBluetoothUUIDSubject.send(uuid)
        }
    }
}

extension BTDeviceDetectedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = subview.window?.windowScene?.screen.bounds.width ?? 390
        return CGSize(width: screenWidth, height: 180)
    }
}
