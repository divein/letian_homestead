#!/bin/bash
# =============================================
# install-ruby.sh 安装ruby (主要为了 puppet..)
# 
# @author wangxinyi <divein@126.com>
# ==============================================
export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(cat '/.letian-stuff/vagrant-core-folder.txt')

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)

# 已经安装过，则跳过 
if [[ -f /.letian-stuff/install-ruby-1.9.3-p551 ]]; then
    exit 0
fi

# 删除系统中旧的ruby
rm -rf /usr/bin/ruby /usr/bin/gem /usr/bin/rvm /usr/local/rvm

# 这里我选择了ruby 1.9.3 ,主要综合评估这个版本兼容最好
echo 'Installing RVM and Ruby 1.9.3'

if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D39DC0E3
elif [[ "${OS}" == 'centos' ]]; then
    gpg2 --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D39DC0E3
fi

### 安装 rvm
curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --ruby=ruby-1.9.3-p551

source /usr/local/rvm/scripts/rvm
## 把 rvm放到/root/的.bashrc 和系统的profile 里, 允许直接使用rvm
if [[ -f '/root/.bashrc' ]] && ! grep -q 'source /usr/local/rvm/scripts/rvm' /root/.bashrc; then
    echo 'source /usr/local/rvm/scripts/rvm' >> /root/.bashrc
fi

if [[ -f '/etc/profile' ]] && ! grep -q 'source /usr/local/rvm/scripts/rvm' /etc/profile; then
    echo 'source /usr/local/rvm/scripts/rvm' >> /etc/profile
fi

/usr/local/rvm/bin/rvm cleanup all

# 更新gem为淘宝源
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
# 更新gem
gem update --system >/dev/null
echo 'y' | rvm rvmrc warning ignore all.rvmrcs

echo 'Finished installing RVM and Ruby 1.9.3'

touch /.letian-stuff/install-ruby-1.9.3-p551
