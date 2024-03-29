
#
# Common functions for testing
#

# The exit code to return when the test run is complete
test_result=0

#
# Call this at the beginning of every test script
#
function testing_begins() {
  local test_script="$(basename $1)"
  local script_under_test="$(basename $2)"

  echo "---------------------------------------------------"
  echo "$test_script: Begin testing $script_under_test ..."
  # set -e
  # set -o errtrace # Enable the err trap, code will get called when an error is detected
  # trap "echo ERROR: There was an error in ${FUNCNAME-main context}, details to follow" ERR

  # set -x
}

#
# Call this at the end of every test script
#
function testing_ends() {
  # set +x
  set +e
  local test_script="$(basename $1)"
  local script_under_test="$(basename $2)"

  echo "$test_script: Testing $script_under_test completed."
  echo "---------------------------------------------------"

  # Any failed test leads to non-zero exit code
  exit $test_result
}

#
# Pretty-print a positive test result
#
function pass() {
  echo -e "\033[32;1mPASS\033[0m"
}

function fail() {
  local retval=$1
  test_result=$retval
  echo -e "\033[31;1mFAIL\033[0m (return code $retval)"
}

function test_eval() {
  local retval=$1
  if [ $retval == 0 ]; then
    pass
  else
    fail $retval
  fi
}
