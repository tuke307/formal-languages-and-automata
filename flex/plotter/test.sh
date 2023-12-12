#!/bin/bash

file1="test_1.spec"
file2="my_output"
file3="test_1.plot"

./plotter $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for $file3 passed :-)"
else
  echo "Test for $file3 failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi

file1="test_2.spec"
file2="my_output"
file3="test_2.plot"

./plotter $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for $file3 passed :-)"
else
  echo "Test for $file3 failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi


file1="test_3.spec"
file2="my_output"
file3="test_3.plot"

./plotter $file3 > $file2

if diff -q "$file1" "$file2" >/dev/null; then
  echo "Test for $file3 passed :-)"
else
  echo "Test for $file3 failed: output of your lexer for $file3 is different from the specification given in $file1."
  diff "$file1" "$file2"
fi

rm $file2