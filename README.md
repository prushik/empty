This simple project shows an example of how a web application might be deployed and the deployment tested for sanity, in this case a static html page, although the webserver configuration provided is fully capable of running PHP code as well.
For this project, the Cherokee webserver is used, along with unix makefiles and shell scripting (which should be mostly free of bashisms).

General configuration for the deployment can be done by editing the file config.make. This file is used for correctly setting values in config files and for verifying the deployed configuration. The defaults should be sane for most deployments.

To deploy the configuration and server content (in production, the content would likely not be in the same repository), from within the project directory, simply type (as root):
 make deploy

This will update configuration files if needed and deploy all configuration and content files, and restart the webserver service or warn that it might be needed.

To perform the testsuite to verify configuration, either launch the tests via the provided web interface, or type:
 make test

This will perform all tests and report any issues in the configuration.
