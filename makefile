.DEFAULT_GOAL := test
include config.make


test: bin/config.sh
	

deploy:
	install etc/key.pem $(PREFIX)/etc/
	install etc/cert.pem $(PREFIX)/etc/
	-install -d $(PREFIX)/etc/cherokee
	install etc/cherokee/cherokee.conf $(PREFIX)/etc/cherokee
	-install -d $(PREFIX)$(WEBROOT)
	install var/www/index.html $(PREFIX)$(WEBROOT)


%.o: %.c
	$(CC) -g $(CFLAGS) -c $< -fno-stack-protector

%.o: %.s
	$(AS) $(ASFLAGS) $<

clean:
	-@rm bin/config.sh

distclean: clean

.PHONY: clean distclean deploy test config
