//
//  browser.h
//  FeedbackCore
//
//  Created by Pedro Santos on 26/11/2020.
//
//  Copyright © 2020 Streambow. All rights reserved.
//


typedef struct {
    double transaction_response_time; // micro seconds
    double transaction_request_rtt;
    double transaction_transfer_time;
    double handshake_rtt;
    double total_size;
} browser_result;

// Returns 0 if connection was able to be established, -1 otherwise
int browser_test(const char * url_or_ip, int timeout, browser_result *result);

int browsing(int argc, char *argv[]);

