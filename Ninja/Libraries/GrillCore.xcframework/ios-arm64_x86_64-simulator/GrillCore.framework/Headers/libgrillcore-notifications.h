//
//  libgrillcore-notifications.h
//  GrillCore
//
//  Created by Sterling on 4/10/23.
//

#ifndef libgrillcore_notifications_h
#define libgrillcore_notifications_h

struct Mantle_Result ios_grillcore_notifications_subscribe(
                                                           const char * _Nonnull dsn,
                                                           const char * _Nonnull group
                                                           );

struct Mantle_Result ios_grillcore_notifications_unsubscribe(
                                                             const char * _Nonnull dsn,
                                                             const char * _Nonnull group
                                                             );

bool ios_grillcore_notifications_has_subscription(
                                                  const char * _Nonnull dsn,
                                                  const char * _Nonnull group
                                                  );

struct Mantle_Result ios_grillcore_notifications_update_token();

#endif /* libgrillcore_notifications_h */
