CronExpression
==============

Description
-----------

Objective C cron expression parser that can parse a CRON expression, determine if it is due to run, and calculate the next run date of the expression. The parser can handle increments of ranges (e.g. */12, 2-59/3), intervals (e.g. 0-9), lists (e.g. 1,2,3), W to find the nearest weekday for a given day of the month, L to find the last day of the month, L to find the last given weekday of a month, and hash (#) to find the nth weekday of a given month.

Initially the library will be packaged for use in iOS but will later be updated to include a Cocoa build target.

This library is ported from the the PHP [cron-expression](https://github.com/mtdowling/cron-expression) library created by [mtdowling](https://github.com/mtdowling).

Progress
--------

This library is currently incomplete. Most of the code has been ported but the unit tests are incomplete. The original PHP code is still included inline as comments.