#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

VBOX_PACK_NAME="MSEdge.Win10.VirtualBox"
VBOX_VM_NAME="MSEdge - Win10"
VBOX_OVA_FILE="${VBOX_VM_NAME}.ova"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          echo "Unknown OS" && exit 1
esac

__install_dep_Linux(){
  sudo apt-get update
  sudo apt-get install -y "${DEP}"
}

__install_dep_Mac(){
  brew cask install "${DEP}"
}

__check_dep(){
  DEP="${1}"
  which "${DEP}" || "__install_dep_${machine}" "${DEP}"
}

_check_deps(){
  __check_dep "wget"
  __check_dep "unzip"
  __check_dep "virtualbox"
}

_download(){
  wget "https://az792536.vo.msecnd.net/vms/VMBuild_20190311/VirtualBox/MSEdge/${VBOX_PACK_NAME}.zip"
}

_extract(){
  unzip "${VBOX_PACK_NAME}.zip"
}

_import_vm(){
  vboxmanage import "${VBOX_OVA_FILE}"
}

_start_vm(){
  vboxmanage startvm "${VBOX_VM_NAME}" --type=gui
}

echo "Checking deps..."
_check_deps >/dev/null 2>&1

echo "Downloading Win10..."
_download >/dev/null 2>&1

echo "Extracting Win10..."
_extract >/dev/null 2>&1

echo "Importing VM Win10 in VirtualBox..."
_import_vm >/dev/null 2>&1

echo "Starting VM Win10..."
_start_vm >/dev/null 2>&1

echo "Done!"
