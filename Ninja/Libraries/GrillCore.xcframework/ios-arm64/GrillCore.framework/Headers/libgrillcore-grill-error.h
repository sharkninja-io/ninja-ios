//
//  libgrillcore-grill-error.h
//  GrillCore
//
//  Created by Jamal Rasheed on 12/13/22.
//

#ifndef libgrillcore_grill_error_h
#define libgrillcore_grill_error_h

typedef struct GrillCore_Grill_Error {
    const uint8_t code;
    const char * _Nonnull time_stamp;
} GrillCore_Grill_Error;

#endif /* libgrillcore_grill_error_h */
