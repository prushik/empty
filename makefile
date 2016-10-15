.DEFAULT_GOAL := test
include config.make


test: bin/config.sh
	bin/tests/00_configs.sh
	bin/tests/01_netstat.sh
	bin/tests/02_wget.sh	

config:
	bin/update_config.sh etc/cherokee/cherokee.conf 'server!bind!1!port' $(HTTP_PORT)
	bin/update_config.sh etc/cherokee/cherokee.conf 'server!bind!2!port' $(HTTPS_PORT)
	bin/update_config.sh etc/cherokee/cherokee.conf 'server!bind!2!tls' 1
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!10!document_root' $(WEBROOT)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!10!hsts' $(HSTS)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!10!hsts!subdomains' $(HSTS)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!20!document_root' $(WEBROOT)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!20!hsts' $(HSTS)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!20!hsts!subdomains' $(HSTS)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!20!ssl_certificate_file' $(SERVER_CERT)
	bin/update_config.sh etc/cherokee/cherokee.conf 'vserver!20!ssl_certificate_key_file' $(SERVER_KEY)

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
