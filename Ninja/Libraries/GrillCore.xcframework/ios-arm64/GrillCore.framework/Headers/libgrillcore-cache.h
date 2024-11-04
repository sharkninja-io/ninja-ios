//
//  libgrillcore-cache.h
//  GrillCore
//
//  Created by Jamal Rasheed on 11/28/22.
//

#ifndef libgrillcore_cache_h
#define libgrillcore_cache_h

struct Mantle_Result ios_grillcore_get_value(
                                             const char *c_path,
                                             const char *c_key
                                             );

struct Mantle_Result ios_grillcore_set_value(
                                             const char *c_path,
                                             const char *c_key,
                                             const struct Cache_Data_Value *ptr_value
                                             );

struct Mantle_Result ios_grillcore_remove_value(
                                                const char *c_path,
                                                const char *c_key
                                                );

#endif /* libgrillcore_cache_h */
