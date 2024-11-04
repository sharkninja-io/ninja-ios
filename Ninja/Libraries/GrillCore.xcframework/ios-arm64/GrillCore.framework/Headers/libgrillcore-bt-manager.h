//
//  libgrillcore-bt-manager.h
//  GrillCore
//
//  Created by Jamal Rasheed on 2/27/23.
//

#ifndef libgrillcore_bt_manager_h
#define libgrillcore_bt_manager_h


void ios_grillcore_process_bt_data(
                                   const char * _Nonnull uuid,
                                   const Mantle_List * _Nonnull data,
                                   int32_t rssi
                                   );

void ios_grillcore_set_request_callback(
                                        void (* _Nonnull state_callback)(const Mantle_List * _Nonnull data)
                                        );

const char * _Nonnull ios_grillcore_get_mac(
                           const char * _Nonnull uuid
                           );

void ios_grillcore_send_bt_payload(
                                   const Mantle_List * _Nonnull data
                                   );

void ios_grillcore_set_bt_available(
                                    bool available
                                  );

const Mantle_List * _Nonnull ios_grillcore_encrypt_data(
                                                        const char * _Nonnull uuid,
                                                        const Mantle_List * _Nonnull data
                                                        );

const Mantle_List * _Nonnull ios_grillcore_decrypt_data(
                                                        const char * _Nonnull uuid,
                                                        const Mantle_List * _Nonnull data
                                                        );

const Mantle_List * _Nonnull ios_grillcore_get_joinable_grills();

#endif /* libgrillcore_bt_manager_h */
