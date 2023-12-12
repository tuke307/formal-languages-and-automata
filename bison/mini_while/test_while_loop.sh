#!/bin/bash

while_file="test/while_test.while"
spec_1="test/while_test_9.spec"
spec_2="test/while_test_34.spec"
spec_3="test/while_test_125.spec"

file_out_1="test/out_test_9.spec"
file_out_6="test/out_test_34.spec"
file_out_12="test/out_test_125.spec"

./mini_while $while_file 9 > $file_out_1
./mini_while $while_file 34 > $file_out_6
./mini_while $while_file 125 > $file_out_12

if diff -q "$spec_1" "$file_out_1" >/dev/null; then
  echo "Test for ./mini_while while_test.while 9 passed :-)"
else
  diff "$spec_1" "$file_out_1"
  echo "Test for ./mini_while while_test.while 9 failed: your output is different from the specification."
fi

if diff -q "$spec_2" "$file_out_6" >/dev/null; then
  echo "Test for ./mini_while while_test.while 34 passed :-)"
else
  diff "$spec_2" "$file_out_6"
  echo "Test for ./mini_while while_test.while 34 failed: your output is different from the specification."
fi

if diff -q "$spec_3" "$file_out_12" >/dev/null; then
  echo "Test for ./mini_while while_test.while 125 passed :-)"
else
  diff "$spec_3" "$file_out_12"
  echo "Test for ./mini_while while_test.while 125 failed: your output is different from the specification."
fi