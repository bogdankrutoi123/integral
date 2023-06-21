CC = gcc
CFLAGS += -std=gnu99 -m32 -no-pie -fno-pie
DEBUG = -g

.DELETE_ON_ERROR:

.PHONY: all
all: main

integral: functions.o integral.c
	$(CC) $(CFLAGS) -o $@ $^ 
  
functions.o: functions.asm
	nasm -f elf32 -o $@ $^
  
.PHONY: clean
clean:
	rm -rf *.o integral
  
.PHONY: test
test: integral
	./integral --test-root 1:2:-3:-1:0.00001:-1.92665
	./integral --test-root 1:3:2:4:0.00001:3.32778
	./integral --test-root 2:3:2:3:0.00001:1.43168
	./integral --test-integral 1:-1:2:0.0001:4.4547
	./integral --test-integral 2:0.5:2.5:0.0001:-1.7287
	./integral --test-integral 3:2:4:0.0001:3.0000