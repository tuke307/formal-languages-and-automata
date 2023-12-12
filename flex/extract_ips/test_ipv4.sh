#!/bin/bash

file1="test_ipv4.spec"
file2="my_output"
file3="test_ipv4.txt"

./extract_ips $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for ipv4 passed :-)"
else
  echo "Test for ipv4 addresses failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi
