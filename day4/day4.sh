#!/usr/bin/env bash

awk -v RS="" -F'\n' -v OFS=' ' '{$1=$1} 1' input.txt | grep 'byr:.*' |
  grep 'iyr:.*' |
  grep 'eyr:.*' |
  grep 'hgt:.*' |
  grep 'hcl:.*' |
  grep 'ecl:.*' |
  grep 'pid:.*' |
  wc -l

awk -v RS="" -F'\n' -v OFS=' ' '{$1=$1} 1' input.txt | grep -E 'byr:(19[2-9][0-9]|200[0-2])(\s|$)' |
  grep -E 'iyr:(201[0-9]|2020)(\s|$)' |
  grep -E 'eyr:(202[0-9]|2030)(\s|$)' |
  grep -E 'hgt:(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)(\s|$)' |
  grep -E 'hcl:\#[a-zA-Z0-9]{6}(\s|$)' |
  grep -E 'ecl:(amb|blu|brn|gry|grn|hzl|oth)(\s|$)' |
  grep -E 'pid:[0-9]{9}(\s|$)' |
  wc -l
