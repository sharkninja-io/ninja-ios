//
//  UIImage+ImageAssetLibrary.swift
//  Ninja
//
//  Created by Martin Burch on 9/7/22.
//

import UIKit

enum ImageAssetLibrary: String, CaseIterable {
    
    case splash_ninja_logo
    case img_ninja_logo
    case img_spinner_ellipse
    case img_screen_cancel_join
    case img_american_plug
    case img_grill_start_button
    case img_plugin_device
    case img_ogxl_angled
    case img_grill_closed
    case img_grill_mode_button
    case img_grill_round_mode_button
    case img_screen_local_network
    case img_iphone_wifi
    case img_wifi_router
    case demo_connect_to_wifi
    case demo_pairing_screen
    case demo_pairing_error_bg
    case demo_grill_open
    case img_outdoor_pro_grill
    case img_grill_error_state
    case img_iphone_BT
    case img_woodfire_gradient
    
    case img_insert_thermometer
    case img_chart_card
    
    case img_aircrisp_basket
    case img_grease_tray
    case img_grill_tray

    
    case grill_states // TODO: Maybe rename? This name came from the Figma
    
    case none = "icoNone"
    
    func asImage() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
    
}

