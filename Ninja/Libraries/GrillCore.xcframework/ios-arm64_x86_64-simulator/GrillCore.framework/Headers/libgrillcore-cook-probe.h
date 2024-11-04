//
//  libgrillcore-cook-probe.h
//  GrillCore
//
//  Created by Sterling on 1/12/23.
//

#ifndef libgrillcore_cook_probe_h
#define libgrillcore_cook_probe_h

typedef struct GrillCore_CookProbe {
    const uint32_t * _Nullable temp;
    uint32_t food;
    const uint32_t * _Nullable preset_index;
    uint32_t probe_mode;
} GrillCore_CookProbe;

#endif /* libgrillcore_cook_probe_h */
