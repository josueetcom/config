# Runs executable, doing a backtrace after a seg fault or verify 333 failure
function verify333 {
  gdb -ex "b VerificationFailure" -ex "r" -ex "bt" $@
}

# searches typedefs and #defines for the label
function cgrep {
  egrep -n "((typedef|}|#define).*$@(;|\\w)|[^=]+ $@\\(.*)" *.h */*.h *.cc
}

# Shortcut aliases for C/C++
alias g++11="g++ -Wall -g -std=c++11"
alias gcc11="gcc -Wall -g -std=c11"
alias lint="~/bin/clint.py"
alias lint++="~/bin/cpplint.py"
alias vg="valgrind --leak-check=full"
alias remake="make clean && make"
