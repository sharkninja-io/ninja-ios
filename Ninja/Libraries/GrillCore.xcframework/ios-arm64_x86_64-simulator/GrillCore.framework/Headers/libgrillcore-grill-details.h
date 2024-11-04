//
//  libgrillcore-grill-details.h
//  GrillCore
//
//  Created by Jamal Rasheed on 12/12/22.
//

#ifndef libgrillcore_grill_details_h
#define libgrillcore_grill_details_h

typedef struct GrillCore_Grill_Details {
    const char * _Nonnull serial;
    const char * _Nonnull model;
    const char * _Nonnull dsn;
    const char * _Nonnull mac;
    const char * _Nonnull fw_version;
    const char * _Nonnull ota_fw_version;
} GrillCore_Grill_Details;

#endif /* libgrillcore_grill_details_h */
