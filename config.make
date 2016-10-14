# set the deployment prefix here, omit the trailing slash
PREFIX		?=	

# set to document root of webserver, omit trailing slash
WEBROOT		?=	/var/www

# set to location (full path) of server private key
SERVER_KEY	?=	/etc/key.pem

# set to location (full path) of server certificate
SERVER_CERT	?=	/etc/cert.pem

# set to HTTP port and HTTPS port respectively
HTTP_PORT	?=	80
HTTPS_PORT	?=	443

# set to a space seperated list of ports allowed open
OPEN_PORTS	?=	80 443 4000

# set to 1 if HSTS (HTTP Strict Transport Security) should be enable, otherwise leave unset or 0
HSTS		?=	1


bin/config.sh:
	@echo -e "##This file is created automatically by config.make, please do not edit\n" > bin/config.sh
	@echo "PREFIX=$(PREFIX)" >> bin/config.sh
	@echo "WEBROOT=$(WEBROOT)" >> bin/config.sh
	@echo "SERVER_KEY=$(SERVER_KEY)" >> bin/config.sh
	@echo "SERVER_CERT=$(SERVER_CERT)" >> bin/config.sh
	@echo "HTTP_PORT=$(HTTP_PORT)" >> bin/config.sh
	@echo "HTTPS_PORT=$(HTTPS_PORT)" >> bin/config.sh
	@echo "OPEN_PORTS=\"$(OPEN_PORTS)\"" >> bin/config.sh
	@echo "HSTS=$(HSTS)" >> bin/config.sh
