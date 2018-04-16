/*Change HEADER_H to whatever */
/* use #DEFINE _M_DEBUG {1 2 3} to get debug */
#define _M_DEBUG 3

#ifndef HEADER_H_
#define HEADER_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <stdbool.h>
#include <time.h>

#include <sys/types.h>
#include <sys/syscall.h>
#define __PID__ getpid()  /* Overide for certain conditions... */

#ifdef SYS_gettid
#define __THREAD__ syscall(SYS_gettid)
#else
/* #error "SYS_gettid unavailable on this system" */
#define __THREAD__ 0
#endif

/* #define _GNU_SOURCE */        /* See feature_test_macros(7) */

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_RESET   "\x1b[0m"

#if defined(_M_DEBUG) && _M_DEBUG > 2
#define info(fmt, args...) fprintf(stderr, ANSI_COLOR_GREEN "INFO  %s:%d:%s():PID:%d:TID:%ld " ANSI_COLOR_RESET fmt "\n", __FILE__, __LINE__, __func__, __PID__, __THREAD__, ##args), fflush(stdout)
#else
#define info(fmt, args...) /* Don't do anything in release builds */
#endif

#if defined(_M_DEBUG) && _M_DEBUG > 1
#define log(fmt, args...) fprintf(stderr, ANSI_COLOR_YELLOW "LOG   %s:%d:%s():PID:%d:TID:%ld " ANSI_COLOR_RESET fmt "\n", __FILE__, __LINE__, __func__, __PID__, __THREAD__, ##args), fflush(stdout)
#else
#define log(fmt, args...) /* Don't do anything in release builds */
#endif

#if defined(_M_DEBUG) && _M_DEBUG > 0
#define err(fmt, args...) fprintf(stderr, ANSI_COLOR_RED "ERROR %s:%d:%s():PID:%d:TID:%ld " ANSI_COLOR_RESET fmt "\n", __FILE__, __LINE__, __func__, __PID__, __THREAD__, ##args), fflush(stdout)
#else
#define err(fmt, args...) /* Don't do anything in release builds */
#endif

int  _test_debug(int argc, char **args) {
  int i = 10;
  info("Welcome");
  info("Here is some info");
  err("oops an error, i was =%d", i);
  log("Debugging is enabled.");
  log("Debug level: %d", i);
  return 0;
}

#endif
