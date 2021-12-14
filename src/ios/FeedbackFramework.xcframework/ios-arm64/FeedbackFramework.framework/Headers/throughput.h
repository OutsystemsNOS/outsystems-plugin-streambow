//
//  throughput.h
//  FeedbackCore
//
//  Created by streambow on 11/07/13.
//
//  Copyright © 2011 Streambow. All rights reserved.
//

#define TIME_BETWEEN_READS_IN_MS 1000.0
#define TIME_BEFORE_FIRST_READ_IN_MS 500.0

//#define _DEBUG

typedef struct {
    double time_request;        // Time to establish the connection in seconds
    double time_transfer;       // Time it took to transfer the file in seconds
    double time_total;          // Total time wasted in the test in seconds
    long total;                 // Total size of bytes
    long transfered;            // Size of bytes transfered
    long throughput_max;        // Maximum throughput in Bps
    long throughput_average;    // Average throughput in Bps
} throughput_result;

typedef struct {
    throughput_result *result;
    long endtime;
    long current;
    long next;
    long prev;
    long prev_bytes;
    long current_bytes;
    int first_time;
    int type;
    long bytesTotal;
    long timeTotal;
} throughput_result_internal;

throughput_result_internal internald;
throughput_result_internal internalu;

// Returns -1 in case of error (e.g. invalid URL), 0 if everything OK and 1 in case of timeout
int throughput_upload_test(const char *url, unsigned long bytes, throughput_result *result, unsigned int timeout, int type, int numParallel);
int throughput_download_test(const char *url, throughput_result *result, unsigned int timeout, int type, int numParallel);

long get_speed(int type);
