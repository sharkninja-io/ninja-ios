//
//  http-client.h
//  MantleUtilities
//
//  Created by Jamal Rasheed on 11/8/22.
//

#ifndef http_client_h
#define http_client_h

typedef struct HTTP_Request {
    const char * _Nonnull url;
    const char * _Nonnull method;
    const Mantle_List * _Nullable body;
    const uint8_t timeout;
    const Mantle_List * _Nonnull headers;
} HTTP_Request;

typedef struct HTTP_Header {
    const char * _Nonnull key;
    const char * _Nonnull value;
} HTTP_Header;

typedef struct HTTP_Response {
    const Mantle_List * _Nonnull content;
    const uint16_t status_code;
} HTTP_Response;

void ios_set_requests_callback(
                               const struct HTTP_Response * _Nonnull (* _Nonnull requests_callback)(const struct HTTP_Request * _Nonnull)
                               );

#endif /* http_client_h */
