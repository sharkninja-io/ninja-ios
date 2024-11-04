//
//  libgrillcore-user.h
//  GrillCore
//
//  Created by Jamal Rasheed on 11/10/22.
//

#ifndef libgrillcore_user_h
#define libgrillcore_user_h

struct Mantle_Result ios_grillcore_confirm_account(
                                                   const char * _Nonnull c_token
                                                   );

struct Mantle_Result ios_grillcore_confirm_account_request(
                                                           const char * _Nonnull c_email,
                                                           const char * _Nullable c_email_template_id,
                                                           const char * _Nullable c_email_subject,
                                                           const char * _Nullable c_email_body_html
                                                           );

struct Mantle_Result ios_grillcore_create_account(
                                                  const char * _Nonnull c_password,
                                                  const char * _Nonnull c_email,
                                                  const char * _Nullable c_email_template_id,
                                                  const char * _Nullable c_email_subject,
                                                  const char * _Nullable c_email_body_html
                                                  );

struct Mantle_Result ios_grillcore_delete_account();

struct Mantle_Result ios_grillcore_get_username();

struct Mantle_Result ios_grillcore_get_uuid();

struct Mantle_Result ios_grillcore_get_access_token();

struct Mantle_Result ios_grillcore_login(
                                         const char * _Nonnull c_password,
                                         const char * _Nonnull c_email
                                         );

struct Mantle_Result ios_grillcore_refresh_session();

struct Mantle_Result ios_grillcore_logout();

bool ios_grillcore_loggedIn();

struct Mantle_Result ios_grillcore_reset_password_request(
                                                          const char * _Nonnull c_email,
                                                          const char * _Nullable c_email_template_id,
                                                          const char * _Nullable c_email_subject,
                                                          const char * _Nullable c_email_body_html
                                                          );

struct Mantle_Result ios_grillcore_reset_password(
                                                  const char * _Nonnull c_token,
                                                  const char * _Nonnull c_password,
                                                  const char * _Nonnull c_password_confirmation
                                                  );

struct Mantle_Result ios_grillcore_reset_user_password(
                                                       const char * _Nonnull c_current_password,
                                                       const char * _Nonnull c_new_password
                                                       );

struct Mantle_Result ios_grillcore_update_email(
                                                const char * _Nonnull c_new_email
                                                );

#endif /* libgrillcore_user_h */
