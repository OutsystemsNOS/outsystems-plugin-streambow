//
//  connectiontime.h
//  FeedbackCore
//
//  Created by streambow on 11/07/20.
//
//  Copyright © 2011 Streambow. All rights reserved.
//

typedef struct {
    double time; // in ms
} connectiontime_result;

// Returns 0 if connection was able to be established, -1 otherwise
int connection_time(const char * url_or_ip, int port, int timeout, double * time_lapsed);
