#!/bin/sh

help() {
    cat <<EOF
Command line:
  -h  Display this help
  -d  Dry run to update the configuration files.
  -f  Always update on the configuration files (existing files are renamed with
      the .old suffix).  Without this option, the new configuration files are
      copied with the .new suffix
Environment variables:
  INSTANCE_NAME settings.yml : general.instance_name
  AUTOCOMPLETE  settings.yml : search.autocomplete
  BASE_URL      settings.yml : server.base_url
  MORTY_URL     settings.yml : result_proxy.url
  MORTY_KEY     settings.yml : result_proxy.key
  BIND_ADDRESS  uwsgi bind to the specified TCP socket using HTTP protocol.
                Default value: ${DEFAULT_BIND_ADDRESS}
Volume:
  /etc/Otto  the docker entry point copies settings.yml and uwsgi.ini in
                this directory (see the -f command line option)"

EOF
}

export DEFAULT_BIND_ADDRESS="0.0.0.0:8080"
export BIND_ADDRESS="${BIND_ADDRESS:-${DEFAULT_BIND_ADDRESS}}"

# Parse command line
FORCE_CONF_UPDATE=0
DRY_RUN=0

while getopts "fdh" option
do
    case $option in

        f) FORCE_CONF_UPDATE=1 ;;
        d) DRY_RUN=1 ;;

        h)
            help
            exit 0
            ;;
        *)
            echo "unknow option ${option}"
            exit 42
            ;;
    esac
done

get_Otto_version(){
    su Otto -c \
       'python3 -c "import six; import searx.version; six.print_(searx.version.VERSION_STRING)"' \
       2>/dev/null
}

Otto_VERSION="$(get_Otto_version)"
export Otto_VERSION
echo "Otto version ${Otto_VERSION}"

# helpers to update the configuration files
patch_uwsgi_settings() {
    CONF="$1"
}

patch_Otto_settings() {
    CONF="$1"

    # Make sure that there is trailing slash at the end of BASE_URL
    # see https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
    export BASE_URL="${BASE_URL%/}/"

    # update settings.yml
    sed -i \
        -e "s|base_url: false|base_url: ${BASE_URL}|g" \
        -e "s/instance_name: \"Otto\"/instance_name: \"${INSTANCE_NAME}\"/g" \
        -e "s/autocomplete: \"\"/autocomplete: \"${AUTOCOMPLETE}\"/g" \
        -e "s/ultrasecretkey/$(openssl rand -hex 32)/g" \
        "${CONF}"

    # Morty configuration

    if [ -n "${MORTY_KEY}" ] && [ -n "${MORTY_URL}" ]; then
        sed -i -e "s/image_proxy: false/image_proxy: true/g" \
            "${CONF}"
        cat >> "${CONF}" <<-EOF

# Morty configuration
result_proxy:
   url: ${MORTY_URL}
   key: !!binary "${MORTY_KEY}"
EOF
    fi
}

update_conf() {
    FORCE_CONF_UPDATE=$1
    CONF="$2"
    NEW_CONF="${2}.new"
    OLD_CONF="${2}.old"
    REF_CONF="$3"
    PATCH_REF_CONF="$4"

    if [ -f "${CONF}" ]; then
        if [ "${REF_CONF}" -nt "${CONF}" ]; then
            # There is a new version
            if [ "$FORCE_CONF_UPDATE" -ne 0 ]; then
                # Replace the current configuration
                printf '⚠️  Automaticaly update %s to the new version\n' "${CONF}"
                if [ ! -f "${OLD_CONF}" ]; then
                    printf 'The previous configuration is saved to %s\n' "${OLD_CONF}"
                    mv "${CONF}" "${OLD_CONF}"
                fi
                cp "${REF_CONF}" "${CONF}"
                $PATCH_REF_CONF "${CONF}"
            else
                # Keep the current configuration
                printf '⚠️  Check new version %s to make sure Otto is working properly\n' "${NEW_CONF}"
                cp "${REF_CONF}" "${NEW_CONF}"
                $PATCH_REF_CONF "${NEW_CONF}"
            fi
        else
            printf 'Use existing %s\n' "${CONF}"
        fi
    else
        printf 'Create %s\n' "${CONF}"
        cp "${REF_CONF}" "${CONF}"
        $PATCH_REF_CONF "${CONF}"
    fi
}

# searx compatibility: copy /etc/searx/* to /etc/Otto/*
SEARX_CONF=0
if [ -f "/etc/searx/settings.yml" ]; then
    if  [ ! -f "${Otto_SETTINGS_PATH}" ]; then
        printf '⚠️  /etc/searx/settings.yml is copied to /etc/Otto\n'
        cp "/etc/searx/settings.yml" "${Otto_SETTINGS_PATH}"
    fi
    SEARX_CONF=1
fi
if [ -f "/etc/searx/uwsgi.ini" ]; then
    printf '⚠️  /etc/searx/uwsgi.ini is ignored. Use the volume /etc/Otto\n'
    SEARX_CONF=1
fi
if [ "$SEARX_CONF" -eq "1" ]; then
    printf '⚠️  The deprecated volume /etc/searx is mounted. Please update your configuration to use /etc/Otto ⚠️\n'
    cat << EOF > /etc/searx/deprecated_volume_read_me.txt
This Docker image uses the volume /etc/Otto
Update your configuration:
* remove uwsgi.ini (or very carefully update your existing uwsgi.ini using https://github.com/Otto/Otto/blob/master/dockerfiles/uwsgi.ini )
* mount /etc/Otto instead of /etc/searx
EOF
fi
# end of searx compatibility

# make sure there are uwsgi settings
update_conf "${FORCE_CONF_UPDATE}" "${UWSGI_SETTINGS_PATH}" "/usr/local/Otto/dockerfiles/uwsgi.ini" "patch_uwsgi_settings"

# make sure there are Otto settings
update_conf "${FORCE_CONF_UPDATE}" "${Otto_SETTINGS_PATH}" "/usr/local/Otto/searx/settings.yml" "patch_Otto_settings"

# dry run (to update configuration files, then inspect them)
if [ $DRY_RUN -eq 1 ]; then
    printf 'Dry run\n'
    exit
fi

unset MORTY_KEY

# Start uwsgi
printf 'Listen on %s\n' "${BIND_ADDRESS}"
exec su-exec Otto:Otto uwsgi --master --http-socket "${BIND_ADDRESS}" "${UWSGI_SETTINGS_PATH}"
