//
//  libgrillcore-wifi-pairing.h
//  GrillCore
//
//  Created by Jamal Rasheed on 11/17/22.
//

#ifndef libgrillcore_wifi_pairing_h
#define libgrillcore_wifi_pairing_h

void ios_grillcore_configure_pairing_manager(
                                             void (* _Nonnull state_callback)(enum CloudCore_WifiPairingState state),
                                             void (* _Nonnull pairing_wifi_network_callback)(const struct Mantle_List * _Nullable),
                                             void (* _Nonnull completed_callback)(struct Mantle_Result result)
                                             );

void ios_grillcore_start_pairing(
                                 const char * _Nullable ip_address
                                 );

void ios_grillcore_continue_pairing();

void ios_grillcore_register_device(
                                   const char * _Nullable dsn,
                                   const char * _Nullable setup_token
                                   );

void ios_grillcore_cancel_pairing();


void ios_grillcore_handle_selected_network(
                                           const struct CloudCore_WifiNetwork * _Nonnull selected_network
                                           );

enum CloudCore_WifiPairingState ios_grillcore_get_pairing_state();

struct Mantle_Result ios_grillcore_write_to_pairing_log(
                                                        const char * _Nonnull c_content
                                                        );

struct Mantle_Result ios_grillcore_get_pairing_log();

#endif /* libgrillcore_wifi_pairing_h */
