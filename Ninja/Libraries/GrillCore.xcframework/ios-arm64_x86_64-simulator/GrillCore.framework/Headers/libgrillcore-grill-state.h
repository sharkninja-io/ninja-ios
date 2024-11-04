//
//  libgrillcore-grill-state.h
//  GrillCore
//
//  Created by Jamal Rasheed on 12/8/22.
//

#ifndef libgrillcore_grill_state_h
#define libgrillcore_grill_state_h

typedef struct GrillCore_GrillPresetFood {
    uint32_t doneness;
    uint32_t protein;
    uint8_t preset_index;
} GrillCore_GrillPresetFood;

typedef struct GrillCore_GrillThermometer {
    bool active;
    bool plugged_in;
    uint16_t desired_temp;
    uint16_t current_temp;
    const struct GrillCore_GrillPresetFood * _Nonnull food;
    uint32_t state;
    uint8_t cook_progress;
    uint8_t resting_progress;
    uint32_t resting_time_completed;
} GrillCore_GrillThermometer;

typedef struct GrillCore_GrillTimer {
    bool on;
    uint16_t desired_temp;
    uint16_t current_temp;
    uint32_t time_set;
    uint32_t time_left;
} GrillCore_GrillTimer;

typedef struct GrillCore_GrillState {
    uint32_t state;
    bool lid_open;
    bool wood_fire;
    uint32_t cook_type;
    uint32_t cook_mode;
    const struct GrillCore_GrillThermometer * _Nonnull probe1;
    const struct GrillCore_GrillThermometer * _Nonnull probe2;
    const struct GrillCore_GrillTimer * _Nonnull oven;
    uint8_t ignition_progress;
    uint8_t preheat_progress;
    uint8_t cook_progress;
    uint8_t resting_progress;
    uint32_t resting_time_completed;
    bool connected_to_internet;
    bool connected_to_bluetooth;
} GrillCore_GrillState;


void ios_grillcore_set_grill_state_callback(
                                            void (* _Nonnull state_callback)(const struct GrillCore_GrillState * _Nonnull state)
                                            );

#endif /* libgrillcore_grill_state_h */
