## Scenario
A production pod writes structured logs to a file. The operations team needs to extract only the error-level lines from those logs for incident analysis without access to the container filesystem.

## Goal
Monitor logs of a Pod and extract only the error lines matching a pattern.

## Requirements
- Pod name: `log-pod`
- Pod image: `busybox:1.36`
- Pod log path: `/var/log/app.log`
- Extract log lines that contain: `error file-not-found`
- Write output to: `/opt/CKA2026/log-pod/errors.log`
