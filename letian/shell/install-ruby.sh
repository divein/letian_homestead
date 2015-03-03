#!/bin/bash
# =============================================
# install-ruby.sh ��װruby (��ҪΪ�� puppet..)
# 
# @author wangxinyi <divein@126.com>
# ==============================================
export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(cat '/.letian-stuff/vagrant-core-folder.txt')

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)

# �Ѿ���װ���������� 
if [[ -f /.letian-stuff/install-ruby-1.9.3-p551 ]]; then
    exit 0
fi

# ɾ��ϵͳ�оɵ�ruby
rm -rf /usr/bin/ruby /usr/bin/gem /usr/bin/rvm /usr/local/rvm

# ������ѡ����ruby 1.9.3 ,��Ҫ�ۺ���������汾�������
echo 'Installing RVM and Ruby 1.9.3'

if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D39DC0E3
elif [[ "${OS}" == 'centos' ]]; then
    gpg2 --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D39DC0E3
fi

### ��װ rvm
curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --ruby=ruby-1.9.3-p551

source /usr/local/rvm/scripts/rvm
## �� rvm�ŵ�/root/��.bashrc ��ϵͳ��profile ��, ����ֱ��ʹ��rvm
if [[ -f '/root/.bashrc' ]] && ! grep -q 'source /usr/local/rvm/scripts/rvm' /root/.bashrc; then
    echo 'source /usr/local/rvm/scripts/rvm' >> /root/.bashrc
fi

if [[ -f '/etc/profile' ]] && ! grep -q 'source /usr/local/rvm/scripts/rvm' /etc/profile; then
    echo 'source /usr/local/rvm/scripts/rvm' >> /etc/profile
fi

/usr/local/rvm/bin/rvm cleanup all

# ����gemΪ�Ա�Դ
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
# ����gem
gem update --system >/dev/null
echo 'y' | rvm rvmrc warning ignore all.rvmrcs

echo 'Finished installing RVM and Ruby 1.9.3'

touch /.letian-stuff/install-ruby-1.9.3-p551
