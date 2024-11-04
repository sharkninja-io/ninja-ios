//
//  MantleCUtilities.h
//  
//
//  Created by Jamal Rasheed on 2/11/22.
//

#ifndef mantle_c_utilities_h
#define mantle_c_utilities_h

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct Mantle_List {
    // This is nullable to allow for empty list
    const void * _Nullable start;
    uint32_t length;
} Mantle_List;

typedef enum Mantle_Result_Tag {
    Mantle_Result_Success,
    Mantle_Result_Fail,
} Mantle_Result_Tag;

typedef struct Mantle_Error_FFI {
    const char * _Nonnull error_type;
    const char * _Nonnull description;
} Mantle_Error_FFI;

typedef struct Mantle_Result {
  Mantle_Result_Tag tag;
    union {
        const void * _Nullable success;
        const Mantle_Error_FFI * _Nullable fail;
    };
} Mantle_Result_With_Error;

#include "http-client.h"

#endif /* mantle_c_utilities_h */
