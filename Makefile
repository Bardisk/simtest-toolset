build-simtxt:
	@make -C simtxt

$(shell mkdir -p apkout)

PKGNR = 20

APKS = $(shell find apks/ -name '*.apk' | head -n $(PKGNR))

depkg:
	@for file in $(APKS); do \
		if apktool d -s $$file -o apkout/$$(basename $$file .apk); then \
			echo succeed\ depkg\ $$file; \
		else \
			rm -r apkout/$$(basename $$file .apk); \
		fi; \
	done;

clean:
	-@rm -r apkout

test:
	@for file in $(APKS); do echo $$file; done;