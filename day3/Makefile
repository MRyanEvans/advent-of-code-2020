default_target: day3

SHELL=bash
CC = gcc
CC_FLAGS = -Wall -g -std=c99

day3: main.c
	mkdir -p out
	$(CC) $(CC_FLAGS) main.c -o out/day3

clean:
	rm -rf out
