//
//  ping.h
//  FeedbackCore
//
//  Created by streambow on 11/07/13.
//
//  Copyright © 2011 Streambow. All rights reserved.
//

typedef struct {
  unsigned int packets;
  unsigned int replies;
  unsigned int lost;
  unsigned int misplaced;
  unsigned int rtt_min;    // in ms
  unsigned int rtt_avg;    // in ms
  unsigned int rtt_max;    // in ms
  unsigned int jitter_min; // in ms
  unsigned int jitter_avg; // in ms
  unsigned int jitter_max; // in ms
} ping_result;

int ping(const char *dst, int packets, int timeout, ping_result *result);
