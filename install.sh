#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/icons"
else
    DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR=$(cd "$(dirname "${0}")" && pwd)

THEME_NAME=Qogir
THEME_VARIANTS=('' '-ubuntu' '-manjaro')
COLOR_VARIANTS=('' '-dark')

usage() {
    printf "%s\n" "Usage: $0 [OPTIONS...]"
    printf "\n%s\n" "OPTIONS:"
    printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
    printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
    printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
    local dest=${1}
    local name=${2}
    local theme=${3}
    local color=${4}

    local THEME_DIR=${dest}/${name}${theme}${color}

    [[ -d ${THEME_DIR} ]] && rm -rf "${THEME_DIR}"

    echo "Installing '${THEME_DIR}'..."

    mkdir -p "${THEME_DIR}"
    cp -r "${SRC_DIR}/COPYING" "${THEME_DIR}"
    cp -r "${SRC_DIR}/AUTHORS" "${THEME_DIR}"

    if [[ "${noapp:-}" == 'true' ]]; then
      cp -r "${SRC_DIR}/src/index-noapp.theme" "${THEME_DIR}/index.theme"
    else
      cp -r "${SRC_DIR}/src/index.theme" "${THEME_DIR}"
    fi

    cp -r "${SRC_DIR}/src/cursors/dist${theme}${color}/cursors" "${THEME_DIR}"

    cd "${THEME_DIR}" || exit 1
    sed -i "s/${name}/${name}${theme}${color}/g" index.theme

    if [[ ${color} == '' ]]; then
        cp -r "${SRC_DIR}"/src/{16,22,24,32,48,96,128,scalable,symbolic} "${THEME_DIR}"
        cp -r "${SRC_DIR}"/links/{16,22,24,32,48,96,128,scalable,symbolic} "${THEME_DIR}"
        [[ ${theme} != '' ]] && \
        cp -r "${SRC_DIR}"/src/theme"${theme}"/* "${THEME_DIR}"
    else
        mkdir -p "${THEME_DIR}/16"
        mkdir -p "${THEME_DIR}/22"
        mkdir -p "${THEME_DIR}/24"
        mkdir -p "${THEME_DIR}/32"
        cp -r "${SRC_DIR}"/src/16/{actions,places,devices} "${THEME_DIR}/16"
        cp -r "${SRC_DIR}"/src/22/{actions,places,devices} "${THEME_DIR}/22"
        cp -r "${SRC_DIR}"/src/24/{actions,places,devices} "${THEME_DIR}/24"
        cp -r "${SRC_DIR}"/src/32/actions "${THEME_DIR}/32"

        sed -i "s/#5d656b/#d3dae3/g" "${THEME_DIR}"/{16,22,24,32}/actions/*
        sed -i "s/#5d656b/#d3dae3/g" "${THEME_DIR}"/{16,22,24}/places/*
        sed -i "s/#5d656b/#d3dae3/g" "${THEME_DIR}"/{16,22,24}/devices/*
        
        cp -r "${SRC_DIR}"/links/16/{actions,places,devices} "${THEME_DIR}/16"
        cp -r "${SRC_DIR}"/links/22/{actions,places,devices} "${THEME_DIR}/22"
        cp -r "${SRC_DIR}"/links/24/{actions,places,devices} "${THEME_DIR}/24"
        cp -r "${SRC_DIR}"/links/32/actions "${THEME_DIR}/32"

        cd "${dest}" || exit 1
        ln -sf "../${name}${theme}/scalable" "${name}${theme}-dark/scalable"
        ln -sf "../${name}${theme}/symbolic" "${name}${theme}-dark/symbolic"
        ln -sf "../${name}${theme}/48" "${name}${theme}-dark/48"
        ln -sf "../${name}${theme}/96" "${name}${theme}-dark/96"
        ln -sf "../${name}${theme}/128" "${name}${theme}-dark/128"
        ln -sf "../../${name}${theme}/16/apps" "${name}${theme}-dark/16/apps"
        ln -sf "../../${name}${theme}/16/emblems" "${name}${theme}-dark/16/emblems"
        ln -sf "../../${name}${theme}/16/mimetypes" "${name}${theme}-dark/16/mimetypes"
        ln -sf "../../${name}${theme}/16/panel" "${name}${theme}-dark/16/panel"
        ln -sf "../../${name}${theme}/16/status" "${name}${theme}-dark/16/status"
        ln -sf "../../${name}${theme}/22/emblems" "${name}${theme}-dark/22/emblems"
        ln -sf "../../${name}${theme}/22/mimetypes" "${name}${theme}-dark/22/mimetypes"
        ln -sf "../../${name}${theme}/22/panel" "${name}${theme}-dark/22/panel"
        ln -sf "../../${name}${theme}/24/animations" "${name}${theme}-dark/24/animations"
        ln -sf "../../${name}${theme}/24/panel" "${name}${theme}-dark/24/panel"
        ln -sf "../../${name}${theme}/32/apps" "${name}${theme}-dark/32/apps"
        ln -sf "../../${name}${theme}/32/devices" "${name}${theme}-dark/32/devices"
        ln -sf "../../${name}${theme}/32/places" "${name}${theme}-dark/32/places"
        ln -sf "../../${name}${theme}/32/status" "${name}${theme}-dark/32/status"
    fi

    cd "${THEME_DIR}" || exit
    ln -sf 16 16@2x
    ln -sf 22 22@2x
    ln -sf 24 24@2x
    ln -sf 32 32@2x
    ln -sf 48 48@2x
    ln -sf 96 96@2x
    ln -sf 128 128@2x
    ln -sf scalable scalable@2x

    if [[ "${noapp:-}" == 'true' ]]; then
      rm -rf "${THEME_DIR}/16/apps"
      rm -rf "${THEME_DIR}/32/apps"
      rm -rf "${THEME_DIR}/32/devices"
      rm -rf "${THEME_DIR}/48/apps"
      rm -rf "${THEME_DIR}/scalable/apps"
      rm -rf "${THEME_DIR}/scalable/devices"
      rm -rf "${THEME_DIR}/symbolic/apps"
    fi

    cd "${dest}" || exit
    gtk-update-icon-cache "${name}${theme}${color}"
}

while [[ $# -gt 0 ]]; do
    case "${1}" in
        -d|--dest)
            dest="${2}"
            if [[ ! -d "${dest}" ]]; then
                echo "ERROR: Destination directory does not exist."
                exit 1
            fi
            shift 2
        ;;
        -n|--name)
            name="${2}"
            shift 2
        ;;
        --noapp)
            noapp='true'
            echo "INFO: Use system app icons."
            shift
        ;;
        -h|--help)
            usage
            exit 0
        ;;
        *)
            echo "ERROR: Unrecognized installation option '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
        ;;
    esac
done

for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
    for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
        install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
done
