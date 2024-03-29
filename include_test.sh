#!/bin/bash

script_under_test=include.sh

# Import test framework
set -e
. src/testing.sh
set +e
testing_begins $0 $script_under_test

# Import the functions under test
echo -n "Testing import of include.sh... "
. $script_under_test 2>/dev/null
test_eval $?

# That's it. Just testing, whether sourcing the include script throws any errors.

# Finished testing
testing_ends $0 $script_under_test
