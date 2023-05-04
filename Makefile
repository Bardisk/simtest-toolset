SHELL := /bin/bash
build-simtxt:
	@make -C simtxt

$(shell mkdir -p build)

build-classifier:
	@g++ -o build/classifier -O2 -Wall -Wextra -std=c++11 classifier/classifier.cpp
	@cp classifier/piclass.txt build/

build-simcalc:
	@g++ -o build/simcalc -O2 -Wall -Wextra -std=c++11 simcalc/simcalc.cpp

$(shell mkdir -p apkout)
$(shell mkdir -p birthmark)

PKGNR = 20

APKS = $(shell find apks/ -name '*.apk' | head -n $(PKGNR))
APKFS = $(addprefix apkout/,$(shell ls apkout/)) 

depkg:
	@for file in $(APKS); do \
		if apktool d -s $$file -o apkout/$$(basename $$file .apk); then \
			echo succeed\ depkg\ $$file; \
		else \
			rm -r apkout/$$(basename $$file .apk); \
		fi; \
	done;

geneb:
	@for dir in $(APKFS); do { \
		if [ -f $$dir/hashlist.txt ]; then continue; fi; \
		echo processing $$dir; \
		for file in $$(find $$dir -name '*.png') $$(find $$dir -name '*.jpg'); do \
			python dhash.py $$file >> $$dir/hashlist.txt; \
		done; \
	} \
	done;
	@for dir in $(APKFS); do { \
		build/classifier <$$dir/hashlist.txt >birthmark/$$(basename $$dir)_birthmark_image.txt; \
	} \
	done;


clean:
	-@rm -r apkout

test:
	@for file in $(APKFS); do echo $$file; done;

.PHONY: test clean geneb depkg build-simtxt build-classifier