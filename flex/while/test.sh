#!/bin/bash

file1="test1.spec"
file2="my_output"
file3="test1.while"

./while $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for $file3 passed :-)"
else
  echo "Test for $file3 failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi

file1="test2.spec"
file2="my_output"
file3="test2.while"

./while $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for $file3 passed :-)"
else
  echo "Test for $file3 failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi

file1="test3.spec"
file2="my_output"
file3="test3.while"

./while $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for $file3 passed :-)"
else
  echo "Test for $file3 failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi
