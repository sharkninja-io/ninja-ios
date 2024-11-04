//
//  Icon+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/7/22.
//

import UIKit

enum IconAssetLibrary: String, CaseIterable {
    
    case ico_checkmark
    case ico_empty
    case ico_error_filled_circle
    case ico_warning
    case ico_list_circle
    case ico_wifi_full
    case ico_wifi_bars_3
    case ico_wifi_bars_2
    case ico_wifi_bars_1
    case ico_wifi_lock
    case ico_lightbulb
    case ico_phone
    case ico_back_button
    case ico_forward_button
    case ico_eye_empty
    case ico_eye_off
    case ico_probe
    case ico_probe_connected
    case ico_probe_unplugged
    case ico_thermometer
    case ico_thermometer_unplugged
    case ico_woodfire
    case ico_arrow_right
    case ico_bbq
    case ico_book_closed
    case ico_cog
    case ico_mode_grill
    case ico_mode_smoke
    case ico_mode_air_crisp
    case ico_mode_roast
    case ico_mode_bake
    case ico_mode_broil
    case ico_mode_dehydrate
    case ico_timer
    case ico_checkmark_circle_fill
    case ico_arrow_circle_small
    case ico_checkmark_circle_small
    case ico_arrow_down
    case ico_arrow_up
    case ico_filter
    case ico_pig
    case ico_cow
    case ico_x_close
    case ico_remove_arrow
    case ico_flip_arrow
    case ico_fire_flame
    case ico_error
   
    case ico_chevron_up
    case ico_chevron_down
    case ico_chevron_right
    case ico_chevron_left
    
    case ico_bell_notification
    case ico_grill
    case ico_smartphone
    case ico_person
    case ico_person_circle
    case ico_person_checkmark
    case ico_chat_bubble_error
    case ico_mail
    case ico_lock
    case ico_preference_sliders
    case ico_logout
    case ico_edit_pencil
    case ico_book
    case ico_chat_bubble
    case ico_exclamation_circle
    case ico_restart
    case ico_trash
    case ico_page
    case ico_page_flip
    case ico_multiple_pages
    
    case ico_chef_hat
    case ico_poultry
    case ico_poultry2
    case ico_beef
    case ico_beef2
    case ico_pork
    case ico_pork2
    case ico_fish
    case ico_fish2
    case ico_doneness_icon
    case ico_carrot
    case ico_cheese
    case ico_apple
    case ico_lambveal
    case ico_more
    
    case ico_bluetooth_offline
    case ico_bluetooth_online
    case ico_wifi_offline
    case ico_wifi_online

    case system_checkbox_checked = "checkmark.square.fill"
    case system_checkbox_unchecked = "square"
    case system_clear_fill = "clear.fill"
    case system_arrow_counterclockwise = "arrow.counterclockwise"
    case system_magnifying_glass = "magnifyingglass"
    case system_chevron_down = "chevron.down"
    case system_chevron_up = "chevron.up"
    case system_xmark = "xmark"
    case system_thumbsup = "hand.thumbsup"
    case system_thumbsdown = "hand.thumbsdown"

    case none = "icoNone"
    case appLogo = "AppLogo"
    case appHalfLogo = "AppHalfLogo"
    
    func asImage() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
    
    func asTemplateImage() -> UIImage? {
        return UIImage(named: self.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    func asSystemImage() -> UIImage? {
        return UIImage(systemName: self.rawValue)
    }
    
    func asTemplateSystemImage() -> UIImage? {
        return UIImage(systemName: self.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
}
