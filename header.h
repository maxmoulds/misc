/*Change HEADER_H to whatever */
/* use #DEFINE DEBUG {1 2 3} to get debug */
#ifndef HEADER_H_
#define HEADER_H_

#include <stdio.h>
#include <stdlib.h>

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_RESET   "\x1b[0m"

#if defined(DEBUG) && DEBUG > 2
#define info(fmt, args...) fprintf(stderr, ANSI_COLOR_GREEN "DEBUG %s:%d:%s(): " ANSI_COLOR_RESET fmt "\n", __FILE__, __LINE__, __func__, ##args)
#else
#define info(fmt, args...) /* Don't do anything in release builds */
#endif

#if defined(DEBUG) && DEBUG > 1
#define trace(fmt, args...) fprintf(stderr, ANSI_COLOR_YELLOW "DEBUG %s:%d:%s(): " ANSI_COLOR_RESET fmt "\n", __FILE__, __LINE__, __func__, ##args)
#else
#define trace(fmt, args...) /* Don't do anything in release builds */
#endif

#if defined(DEBUG) && DEBUG > 0
#define err(fmt, args...) fprintf(stderr, ANSI_COLOR_RED "DEBUG %s:%d:%s(): " ANSI_COLOR_RESET fmt "\n", __FILE__, __LINE__, __func__, ##args)
#else
#define err(fmt, args...) /* Don't do anything in release builds */
#endif

int  _test_debug(int argc, char **args) {
  int i = 10;
  info("Welcome");
  info("Here is some info");
  err("oops an error, i was =%d", i);
  trace("Debugging is enabled.");
  trace("Debug level: %d", i);
  return 0;
}

#endif
