#!/bin/bash

file1="test_ipv6.spec"
file2="my_output"
file3="test_ipv6.txt"

./extract_ips $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for ipv6 passed :-)"
else
  echo "Test for ipv6 addresses failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2" 
fi

rm $file2