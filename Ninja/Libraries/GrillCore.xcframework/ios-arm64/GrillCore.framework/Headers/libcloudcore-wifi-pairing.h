//
//  libcloudcore-wifi-pairing.h
//  GrillCore
//
//  Created by Jamal Rasheed on 11/17/22.
//

#ifndef libcloudcore_wifi_pairing_h
#define libcloudcore_wifi_pairing_h

typedef enum CloudCore_WifiPairingState {
    CloudCore_WifiPairingState_Idle,
    CloudCore_WifiPairingState_FetchingDSN,
    CloudCore_WifiPairingState_DeviceScanningWifi,
    CloudCore_WifiPairingState_GettingWifiNetworks,
    CloudCore_WifiPairingState_SendingWiFiCredentialsToDevice,
    CloudCore_WifiPairingState_EndingAccessPointsScanning,
    CloudCore_WifiPairingState_PollingUserInternetConnection,
    CloudCore_WifiPairingState_HandshakingWithAyla,
    CloudCore_WifiPairingState_PollingDeviceOnAyla,
    CloudCore_WifiPairingState_Connected,
    CloudCore_WifiPairingState_Done,
    CloudCore_WifiPairingState_Cancelling
} CloudCore_WifiPairingState;

typedef struct CloudCore_WifiNetwork {
    const uint32_t * _Nullable bars;
    const char * _Nullable bssid;
    const uint32_t * _Nullable chan;
    const char * _Nullable security;
    const int32_t * _Nullable signal;
    const char * _Nullable ssid;
    const char * _Nullable type;
    const char * _Nullable password;
} CloudCore_WifiNetwork;

#endif /* libcloudcore_wifi_pairing_h */
