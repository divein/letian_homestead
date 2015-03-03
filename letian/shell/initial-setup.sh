#!/bin/bash
# =============================================
# vagrant ������ĳ�ʼ���ű� initial-setup.sh
# 
# @author wangxinyi <divein@126.com>
# ==============================================

export DEBIAN_FRONTEND=noninteractive

# ���� vagrant �ĺ���Ŀ¼, ����Ϊ /vagrant/letian
VAGRANT_CORE_FOLDER=$(echo "$1")

##\ ��ȡϵͳ��Ϣ
# ��ȡOS 
OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
# ��ȡCODENAME
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)
# ��ȡ�汾
RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)

##\ ��ʼ,��ʾ��ʾ��Ϣ
cat "${VAGRANT_CORE_FOLDER}/shell/ascii-art/self-promotion.txt"
printf "\n"
echo ""

##\ ����stuff Ŀ¼ 
if [[ ! -d '/.letian-stuff' ]]; then
    mkdir '/.letian-stuff'
    echo 'Created directory /.letian-stuff'
fi
# �������� vagrant core folder
touch '/.letian-stuff/vagrant-core-folder.txt'
echo "${VAGRANT_CORE_FOLDER}" > '/.letian-stuff/vagrant-core-folder.txt'

# ���Ӹ�ʱ����ļ����������� apt-get update �ٴ�ִ�� 
if [[ ! -f '/.letian-stuff/initial-setup-repo-update-11052014' ]]; then
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
        echo 'Running datestamped initial-setup apt-get update'
        apt-get update >/dev/null
        touch '/.letian-stuff/initial-setup-repo-update-11052014'
        echo 'Finished running datestamped initial-setup apt-get update'
    fi
fi

# ��ֹ�ظ�ִ��initial �ű�
if [[ -f '/.letian-stuff/initial-setup-base-packages' ]]; then
    exit 0
fi

##\ ��ʼ��ϵͳ����
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
    
    # ��Ҫ��װ curl ������
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
