FROM nginx:latest

# Default environment (can be overridden with --build-arg)
ARG ENVIRONMENT=local

# Copy the corresponding config file based on ENVIRONMENT value
COPY default.${ENVIRONMENT}.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html