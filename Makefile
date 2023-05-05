SHELL := /bin/bash
build-simtxt:
	@make -C simtxt clean
	@make -C simtxt

$(shell mkdir -p build)

build-classifier:
	@g++ -o build/classifier -O2 -Wall -Wextra -std=c++11 classifier/classifier.cpp
	@cp classifier/piclass.txt build/

build-simcalc:
	@g++ -o build/simcalc -O2 -Wall -Wextra -std=c++11 simcalc/simcalc.cpp

$(shell mkdir -p apkout)
$(shell mkdir -p birthmark)

PKGNR = 200

APKS = $(shell find apks/ -name '*.apk' | head -n $(PKGNR)) 

# all: depkg geneb

all: build-simtxt build-classifier
	@for file in $(APKS); do {\
		./routine.sh $$file; \
	} done;

clean:
	-@rm -r apkout

test:
	@for file in $(APKFS); do echo $$file; done;

.PHONY: test clean geneb depkg build-simtxt build-classifier build-simcalc all