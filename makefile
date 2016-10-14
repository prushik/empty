.DEFAULT_GOAL := test
include config.make


test: bin/config.sh
	bin/tests/01_netstat.sh
	bin/tests/02_wget.sh	

deploy:
	install etc/key.pem $(PREFIX)/etc/
	install etc/cert.pem $(PREFIX)/etc/
	-install -d $(PREFIX)/etc/cherokee
	install etc/cherokee/cherokee.conf $(PREFIX)/etc/cherokee
	-install -d $(PREFIX)$(WEBROOT)
	install var/www/index.html $(PREFIX)$(WEBROOT)
ifeq ($(RESTART_SERVICE),1)
	-/etc/init.d/cherokee restart
else
	@echo
	@echo "###################################################################################################"
	@echo "WARNING! Services were not restarted! If configuration changed, you must restart services manually!"
	@echo "###################################################################################################"
	@echo
endif

%.o: %.c
	$(CC) -g $(CFLAGS) -c $< -fno-stack-protector

%.o: %.s
	$(AS) $(ASFLAGS) $<

clean:
	-@rm bin/config.sh

distclean: clean

.PHONY: clean distclean deploy test config
