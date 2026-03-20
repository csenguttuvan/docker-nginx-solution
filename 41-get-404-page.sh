#!/bin/sh

# This script will fetch the latest 404 custom error page

# Now redundant

set -e


curl -f "https://raw.githubusercontent.com/asmithdt/docker-nginx-problem/main/404.html" -o ${ERROR_PAGE_DIR}/404.html # writes output from curl to this file meaning this directory should exist var/www/nginx/errors
