# Nginx problem

This repository contains a Dockerfile which extends the official nginx container image to create a microservice. The microservice is called bouncer and is responsible for incoming connections that are not recognised by any external load balacing rules, they will fall through to this service.

Bouncer's resposibilities are:

* Redirecting a HTTP request to HTTPS via a 301 redirect
* Returning a custom 404 page **

There are multiple issues to be found with this repository, you are tasked with fixing the problems with this container and writing up your findings as to why it was broken. Please also write any observations about the implementation of this microservice that could be problematic. To make changes you will need to rebuild the image before running it again. 

To build the container:

`docker build --tag local/nginx-problem .`

To run the container in the foreground:

`docker run -p 80:80 -p 443:443 --interactive --tty local/nginx-problem`

To run the container in the background:

`docker run --detach -p 80:80 -p 443:443 --interactive --tty local/nginx-problem`

To spawn a shell in a running container:

`docker ps` - this will show running containers
`docker exec --interactive --tty <container id/name> /bin/bash` - this will insert you into a shell on the running container

## Requirements:

* The container requires internet access to run
* Online nginx configuration documentation or other websites may be helpful to resolve it

** Custom 404 page should look like this:
![404](./404.png)



## Bugs Found and solved

- BUG 1: Key name mismatch between generate-cert file and nginx conf file. This caused nginx to fail at startup
- BUG 2: Moved mkdir command above the script file as the 41 script needs the directory to write the output file to
- BUG 3: 41-get-404-page.sh was faiing silently due to set -e because the file was not executable, so the custom 404 page was not downloaded
- BUG 4: Needed an internal process to execute, when the general catch all location block catches a 404

## Observations

1. curl -s fails silently, so we can't see if it's errored out.
2. The Custom 404 page is being pulled from github. If there github repo were to be removed, it'll cause issues with the custom page.
3. No health check for docker container
4. Hardcoded directory path and key name causes consistency issues
5. Self signed Cert will expire in 30 days, ok for testing and Dev, but will break prod after 30 days
6. SSL Hardening is needed as the bouncer is the entrypoint for the server, so the first surface the internet touches

## Improvements
1. curl -s has been changed to curl -f
2. The Custom 404 page is being pulled from the local directory rather than curling from github
3. Health check added
4. Added ENV variables for both the nginx directory and key name
5. Added TLS Encryption

## Container startup flow with ENV variables

Container starts
      ↓
20-envsubst-on-templates.sh runs
      ↓
Reads  /etc/nginx/templates/nginx.conf.template
      ↓
Replaces ${CERT_NAME} → localhost
Replaces ${ERROR_PAGE_DIR} → /var/www/nginx/errors
      ↓
Outputs to /etc/nginx/nginx.conf  ← because of your ENV override
      ↓
nginx starts reading /etc/nginx/nginx.conf ✅
