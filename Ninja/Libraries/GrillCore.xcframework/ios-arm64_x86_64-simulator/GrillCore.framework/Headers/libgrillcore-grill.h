//
//  libgrillcore-grill.h
//  GrillCore
//
//  Created by Jamal Rasheed on 12/8/22.
//

#ifndef libgrillcore_grill_h
#define libgrillcore_grill_h

typedef struct GrillCore_Grill {
    const char * _Nonnull dsn;
    const struct GrillCore_GrillState * _Nonnull state;
} GrillCore_Grill;

struct Mantle_Result ios_grillcore_grill_get_name(
                                                  const char * _Nonnull c_dsn
                                                  );

struct Mantle_Result ios_grillcore_grill_set_name(
                                                  const char * _Nonnull c_dsn,
                                                  const char * _Nonnull c_new_name
                                                  );

struct Mantle_Result ios_grillcore_grill_details(
                                                 const char * _Nonnull c_dsn
                                                 );

struct Mantle_Result ios_grillcore_grill_errors(
                                                 const char * _Nonnull c_dsn
                                                 );


struct Mantle_Result ios_grillcore_grill_delete(
                                                const char * _Nonnull c_dsn
                                                );

struct Mantle_Result ios_grillcore_grill_factory_reset(
                                                       const char * _Nonnull c_dsn
                                                       );

struct Mantle_Result ios_grillcore_grill_turn_off(
                                                  const char * _Nonnull c_dsn
                                                  );

const struct GrillCore_Cook * _Nullable ios_grillcore_grill_get_last_cook();

struct Mantle_Result ios_grillcore_grill_stop_cook();

struct Mantle_Result ios_grillcore_grill_skip_preheat();

void ios_grillcore_set_grills_callback(
                                       void (* _Nonnull grills_callback)(const struct Mantle_List * _Nonnull)
                                       );

#endif /* libgrillcore_grill_h */
