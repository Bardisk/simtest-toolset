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
		if [ -d apkout/$$(basename $$file .apk) ]; then continue; fi; \
		if apktool d -s $$file -o apkout/$$(basename $$file .apk); then \
			echo succeed\ depkg\ $$file; \
		else \
			{ rm -r apkout/$$(basename $$file .apk); continue; } \
		fi; \
		if [ -f apkout/$$(basename $$file .apk)/hashlist.txt ]; then continue; fi; \
		echo processing apkout/$$(basename $$file .apk) images; \
		for fn in $$(find apkout/$$(basename $$file .apk)/res -name '*.png') $$(find apkout/$$(basename $$file .apk)/assets -name '*.png'); do \
			python dhash.py $$fn >> apkout/$$(basename $$file .apk)/hashlist.txt; \
		done; \
		build/classifier <apkout/$$(basename $$file .apk)/hashlist.txt >birthmark/$$(basename apkout/$$(basename $$file .apk))_birthmark_image.txt; \
		if [ -f apkout/$$(basename $$file .apk)/txtall.txt ]; then continue; fi; \
		echo processing apkout/$$(basename $$file .apk) texts; \
		for fn in $$(find apkout/$$(basename $$file .apk)/res -name '*.xml') $$(find apkout/$$(basename $$file .apk)/assets -name '*.xml'); do \
			cat $$fn >> apkout/$$(basename $$file .apk)/txtall.txt; \
		done; \
		simtxt/build/simtxt -is -D apkout/$$(basename $$file .apk) <apkout/$$(basename $$file .apk)/txtall.txt; \
		rm -r apkout/$$(basename $$file .apk); \
	} done;

clean:
	-@rm -r apkout

test:
	@for file in $(APKFS); do echo $$file; done;

.PHONY: test clean geneb depkg build-simtxt build-classifier build-simcalc all