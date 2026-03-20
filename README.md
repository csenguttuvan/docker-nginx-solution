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



Bugs Solved:
# BUG 1: Key name mismatch between generate-cert fie and nginx conf file (Corrected)

# BUG 2: Moved mkdir command above the script file as the 41 script needs the directory to write the output to first

# BUG 3: 41-get-404-page.sh was faiing silently due to set -e because the file was not executable.

# BUG 4: Needed an internal process to execute, when the general catch all location block catches a 404

Observations:
1. curl -s fails silently, so we can't see if it's errored out (add -f)
2. The Custom 404 page is being pulled from github, no consistency
3. No health check for docker container (Added)
4. Perhaps a way to use variable to match up the output directory to the alias directory, if anything changes
5. Use Env variable for keynames
