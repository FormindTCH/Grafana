## Author - Ismael TREGAROT - May 2023
## This is a Dockerfile meant to build Forshield's provisioned Grafana image.

FROM grafana/grafana:9.5.1

##################################################################
## CONFIGURATION
##################################################################

## Set Grafana options
ENV GF_ENABLE_GZIP=true
ENV GF_USERS_DEFAULT_THEME=dark

## Disable Explore
ENV GF_EXPLORE_ENABLED=false

## Set Home Dashboard
ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/forshield.json

## Install additional plugins
RUN grafana-cli plugins install marcusolsson-dynamictext-panel

##################################################################
## COPY ARTIFACTS (required for provisioning)
##################################################################

## Copy datasource provisioning file
COPY provisioning/datasource.yaml /etc/grafana/provisioning/datasources/postgres.yaml

# Copy dashboard provider file
COPY provisioning/providers.yaml /etc/grafana/provisioning/dashboards/providers.yaml

# Copy dashboard template
COPY provisioning/forshield-dashboard.json /etc/grafana/provisioning/dashboards/forshield.json

##################################################################
## VISUAL CUSTOMIZATION
##################################################################

## Replace Favicon
COPY img/fav32.png /usr/share/grafana/public/img

## Replace Logo
COPY img/logo.svg /usr/share/grafana/public/img/grafana_icon.svg

## Update Background
COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
COPY img/background.svg /usr/share/grafana/public/img/g8_login_light.svg

## Start Grafana
CMD ["grafana-server"]
