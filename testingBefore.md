Baseline strace testing: working.
-->btrace_test added to MAKEFILE
Feature B filtering alone: WORKING
Feature C child tracing alone: WORKING

**PROBLEM:**
Feature B + C together: PARTIALLY WORKING, but child filter inheritance seems buggy (strace -e trace=fork,write,wait forktracetest)
most likely: when fork happens, the child inherits tracing ON, but does not inherit the same trace mask/filter.