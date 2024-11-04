//
//  libgrillcore.h
//  grillcore
//
//  Created by Jamal Rasheed on 11/4/22.
//

#ifndef libgrillcore_h
#define libgrillcore_h

#include "mantle-c-utilities.h"
#include "libcloudcore-wifi-pairing.h"
#include "libcloudcore-cache.h"

void ios_grillcore_init(const char * _Nonnull c_os_dir, const char * _Nonnull c_json_dir);

void ios_grillcore_set_session_params(bool use_dev);

#include "libgrillcore-user.h"
#include "libgrillcore-wifi-pairing.h"
#include "libgrillcore-cache.h"
#include "libgrillcore-grill.h"
#include "libgrillcore-grill-state.h"
#include "libgrillcore-grill-manager.h"
#include "libgrillcore-grill-details.h"
#include "libgrillcore-grill-error.h"
#include "libgrillcore-cook.h"
#include "libgrillcore-cook-probe.h"
#include "libgrillcore-bt-manager.h"
#include "libgrillcore-notifications.h"

#endif /* libgrillcore_h */
