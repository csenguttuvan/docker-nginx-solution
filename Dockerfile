FROM nginx:1.21

ENV CERT_NAME=localhost
ENV ERROR_PAGE_DIR=/var/www/nginx/errors
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx


RUN mkdir -p ${ERROR_PAGE_DIR}
# BUG 2: Moved mkdir command above the script file as the 41 script needs the directory to write the output to first
RUN mkdir -p /etc/nginx/templates


COPY 40-generate-cert.sh /docker-entrypoint.d/
COPY 41-get-404-page.sh /docker-entrypoint.d/
# COPY nginx.conf /etc/nginx/ - envsubst will now generate nginx.conf from the template

COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template

RUN chmod +x /docker-entrypoint.d/41-get-404-page.sh
# BUG 3: 41-get-404-page.sh was faiing silentlt due to set -e because the file was not executable.

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -vkl http://localhost || exit 1

ENV NGINX_ENTRYPOINT_QUIET_LOGS=1

# Nginx image auto runs all scripts in the docker-entrypoint.d directory in alphabetical order at container start up
