//
//  libgrillcore-grill-manager.h
//  GrillCore
//
//  Created by Jamal Rasheed on 12/8/22.
//

#ifndef libgrillcore_grill_manager_h
#define libgrillcore_grill_manager_h

const struct Mantle_List * _Nonnull ios_grillcore_grill_manager_get_grills();

struct Mantle_Result ios_grillcore_grill_manager_fetch_grills();

void ios_grillcore_grill_manager_set_selected_grill(
                                            const char * _Nonnull c_dsn
                                            );
const struct GrillCore_Grill * _Nullable ios_grillcore_grill_manager_get_selected_grill();

#endif /* libgrillcore_grill_manager_h */
