//
//  libcloudcore-cache.h
//  CloudCore
//
//  Created by Jonathan on 11/22/21.
//

#ifndef libcloudcore_cache_h
#define libcloudcore_cache_h

typedef enum {
    CDV_STRING_VALUE,
    CDV_INTEGER_VALUE,
    CDV_DOUBLE_VALUE,
    CDV_BOOLEAN_VALUE,
    CDV_OBJECT_VALUE,
    CDV_NULL_VALUE,
} Cache_Data_Value_Tag;

typedef struct Cache_Data_Value {
    Cache_Data_Value_Tag tag;
    union {
        const char *string;
        const int32_t integer;
        const double float_double;
        const bool boolean;
        const char *object;
    };
} Cache_Data_Value;

#endif /* libcloudcore_cache_h */
