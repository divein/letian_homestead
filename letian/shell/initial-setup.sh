#!/bin/bash
# =============================================
#  initial-setup.sh
# 
# @author wangxinyi <divein@126.com>
# ==============================================

export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(echo "$1")

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)
RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)

cat "${VAGRANT_CORE_FOLDER}/shell/ascii-art/self-promotion.txt"
printf "\n"
echo ""

if [[ ! -d '/.letian-stuff' ]]; then
    mkdir '/.letian-stuff'
    echo 'Created directory /.letian-stuff'
fi

touch '/.letian-stuff/vagrant-core-folder.txt'
echo "${VAGRANT_CORE_FOLDER}" > '/.letian-stuff/vagrant-core-folder.txt'

if [[ ! -f '/.letian-stuff/initial-setup-repo-update-11052014' ]]; then
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
        echo 'Running datestamped initial-setup apt-get update'
        apt-get update >/dev/null
        touch '/.letian-stuff/initial-setup-repo-update-11052014'
        echo 'Finished running datestamped initial-setup apt-get update'
    fi
fi

if [[ -f '/.letian-stuff/initial-setup-base-packages' ]]; then
    exit 0
fi

if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    echo 'Running initial-setup apt-get update'
    apt-get update >/dev/null
    echo 'Finished running initial-setup apt-get update'

    echo 'Installing curl'
    apt-get -y install curl >/dev/null
    echo 'Finished installing curl'

    echo 'Installing git'
    apt-get -y install git-core >/dev/null
    echo 'Finished installing git'
	
    if [[ "${CODENAME}" == 'lucid' || "${CODENAME}" == 'precise' ]]; then
        echo 'Installing basic curl packages'
        apt-get -y install libcurl3 libcurl4-gnutls-dev curl >/dev/null
        echo 'Finished installing basic curl packages'
    fi

    echo 'Installing build-essential packages'
    apt-get -y install build-essential >/dev/null
    echo 'Finished installing build-essential packages'
fi

touch '/.letian-stuff/initial-setup-base-packages'
