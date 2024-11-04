//
//  BTNameDeviceViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/28/22.
//

import UIKit

class BTNameDeviceViewController: BTPairingBaseViewController<BTNameDeviceView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.nameTextWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.nameChanged() }
        subview.nameTextWrapper.dontClearPlaceholderOnEdit()
        subview.nameTextWrapper.placeholder = viewModel.currentDeviceName
        subview.continueButton.onEvent{ [weak self] _ in self?.showConfirmationModal() }
        subview.updateName()
    
        viewModel.getDeviceInfo()
        Logger.Debug("BT_PAIRING: NAME DEVICE")
    }
    
    func nameChanged() {
        let name = subview.nameTextWrapper.textField.text
        if let name = name, !name.isEmpty {
            if name.count <= viewModel.maxNameLength {
                subview.hideMessage()
                viewModel.currentDeviceName = name
            } else {
                let concat = String(name.prefix(viewModel.maxNameLength))
                subview.nameTextWrapper.textField.text = concat
                subview.showNameTooLongMessage()
                viewModel.currentDeviceName = name
            }
        } else {
            viewModel.currentDeviceName = viewModel.defaultGrillName
        }
        subview.updateName()
    }
    
    func showConfirmationModal() {
        let vc = AlertModalViewController(
            title: "Hello there!",
            description: "I’m your new cooking partner, \(viewModel.currentDeviceName).",
            topIcon: IconAssetLibrary.ico_checkmark_circle_fill.asImage()?.tint(color: ColorThemeManager.shared.theme.primaryAccentColor),
            image: ImageAssetLibrary.img_grill_closed.asImage(),
            primaryAction: .init(title: "Let's Get Started".uppercased(), buttonStyle: .primaryButton, alertAction: { [weak self] in
                self?.navigationController?.pushViewController(BTPromptToConnectWifiViewController(), animated: true)
            }),
            preventDismissalWithoutAction: true
        )
        
        present(vc, animated: true)

        // For some unknown reason, not only are these lines necessary, but they have to come AFTER presenting the modal... ~Rick
        vc.subview.mainStack.setCustomSpacing(32, after: vc.subview.topIcon)
        vc.subview.mainStack.spacing = 70
        Logger.Debug("BT_PAIRING: NAME DEVICE: \(viewModel.currentDeviceName)")
    }
}
