#!/bin/bash
# =============================================
# vagrant 启动后的初始化脚本 initial-setup.sh
# 
# @author wangxinyi <divein@126.com>
# ==============================================

export DEBIAN_FRONTEND=noninteractive

# 设置 vagrant 的核心目录, 这里为 /vagrant/letian
VAGRANT_CORE_FOLDER=$(echo "$1")

##\ 获取系统信息
# 获取OS 
OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
# 获取CODENAME
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)
# 获取版本
RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)

##\ 开始,显示提示信息
cat "${VAGRANT_CORE_FOLDER}/shell/ascii-art/self-promotion.txt"
printf "\n"
echo ""

##\ 建立stuff 目录 
if [[ ! -d '/.letian-stuff' ]]; then
    mkdir '/.letian-stuff'
    echo 'Created directory /.letian-stuff'
fi
# 用来保存 vagrant core folder
touch '/.letian-stuff/vagrant-core-folder.txt'
echo "${VAGRANT_CORE_FOLDER}" > '/.letian-stuff/vagrant-core-folder.txt'

# 增加个时间戳文件，用来控制 apt-get update 再次执行 
if [[ ! -f '/.letian-stuff/initial-setup-repo-update-11052014' ]]; then
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
        echo 'Running datestamped initial-setup apt-get update'
        apt-get update >/dev/null
        touch '/.letian-stuff/initial-setup-repo-update-11052014'
        echo 'Finished running datestamped initial-setup apt-get update'
    fi
fi

# 防止重复执行initial 脚本
if [[ -f '/.letian-stuff/initial-setup-base-packages' ]]; then
    exit 0
fi

##\ 初始化系统环境
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
    
    # 需要安装 curl 基础包
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
