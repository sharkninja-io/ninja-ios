//
//  libgrillcore-cook.h
//  GrillCore
//
//  Created by Sterling on 1/12/23.
//

#ifndef libgrillcore_cook_h
#define libgrillcore_cook_h

#include <GrillCore/libgrillcore-cook-probe.h>

typedef struct GrillCore_Cook {
    bool can_smoke;
    const uint32_t cook_type;
    const uint32_t * _Nullable duration;
    bool smoke;
    const uint32_t mode;
    const struct GrillCore_CookProbe * _Nullable probe_0;
    const struct GrillCore_CookProbe * _Nullable probe_1;
    const uint32_t * _Nullable temp;
} GrillCore_Cook;

struct GrillCore_Cook * _Nonnull ios_grillcore_cook_init();

typedef struct GrillCore_FoodPreset {
    const uint32_t preset_index;
    const uint32_t temp;
    const char * _Nonnull temp_description;
} GrillCore_FoodPreset;

const struct Mantle_List * _Nonnull ios_grillcore_cook_get_available_cook_modes(const char * _Nonnull c_class);

const struct Mantle_List * _Nonnull ios_grillcore_cook_get_available_temps(
                                                                           const uint32_t c_mode
                                                                           );

const char * _Nonnull ios_grillcore_cook_get_available_temps_unit(
                                                                  const uint32_t c_mode
                                                                  );

const uint32_t ios_grillcore_cook_get_default_temp(
                                                   const uint32_t c_mode
                                                   );

const struct Mantle_List * _Nonnull ios_grillcore_cook_get_available_times(
                                                                           const uint32_t c_mode
                                                                           );

const char * _Nonnull ios_grillcore_cook_get_available_times_unit(
                                                                  const uint32_t c_mode
                                                                  );

const uint32_t ios_grillcore_cook_get_default_time(
                                                   const uint32_t c_mode
                                                   );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_cook_mode(
                                                                        const struct GrillCore_Cook * _Nonnull,
                                                                        const uint32_t c_mode
                                                                        );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_cook_type_timed(
                                                                              const struct GrillCore_Cook * _Nonnull,
                                                                              const uint32_t c_duration
                                                                              );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_duration(
                                                                       const struct GrillCore_Cook * _Nonnull,
                                                                       const uint32_t c_duration
                                                                       );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_smoke(
                                                                     const struct GrillCore_Cook * _Nonnull,
                                                                     const bool c_smoke
                                                                     );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_probe0_manual(
                                                                            const struct GrillCore_Cook * _Nonnull,
                                                                            const uint32_t c_temp
                                                                            );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_probe0_preset(
                                                                            const struct GrillCore_Cook * _Nonnull,
                                                                            const uint32_t c_food,
                                                                            const uint32_t c_preset_index
                                                                            );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_probe1_manual(
                                                                            const struct GrillCore_Cook * _Nonnull,
                                                                            const uint32_t c_temp
                                                                            );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_probe1_preset(
                                                                            const struct GrillCore_Cook * _Nonnull,
                                                                            const uint32_t c_food,
                                                                            const uint32_t c_preset_index
                                                                            );

const struct GrillCore_Cook * _Nonnull ios_grillcore_cook_set_temp(
                                                                   const struct GrillCore_Cook * _Nonnull,
                                                                   const uint32_t c_temp
                                                                   );

struct Mantle_Result ios_grillcore_cook_sync(
                                             const struct GrillCore_Cook * _Nonnull
                                             );

const struct Mantle_List * _Nonnull ios_grillcore_cook_get_available_foods();

const struct Mantle_List * _Nonnull ios_grillcore_cook_get_food_presets(
                                                                        const uint32_t c_food
                                                                        );

const char * _Nonnull ios_grillcore_cook_get_probe_presets();

#endif /* libgrillcore_cook_h */
