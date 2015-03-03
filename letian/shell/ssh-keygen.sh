#!/bin/bash
# =============================================
# ssh-keygen.sh 生成ssh 的key
# 
# @author wangxinyi <divein@126.com>
# ==============================================
VAGRANT_CORE_FOLDER=$(cat '/.letian-stuff/vagrant-core-folder.txt')

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
VAGRANT_SSH_USERNAME=$(echo "$1")

# 建立ssh key
function create_key()
{
    # key 名字，这里一般会有 root_id_rsa 和 id_rsa
    BASE_KEY_NAME=$(echo "$1")

    if [[ ! -f "${VAGRANT_CORE_FOLDER}/files/dot/ssh/${BASE_KEY_NAME}" ]]; then
        ssh-keygen -f "${VAGRANT_CORE_FOLDER}/files/dot/ssh/${BASE_KEY_NAME}" -P ""
        # 注意:生成 putty 格式的 ssh key(putty 是ppk格式，和 ssh-keygen 生成的 openssh 格式的不一样
		# 这样，vagrant 在windows 下就能ssh 到vm 了。
        if [[ ! -f "${VAGRANT_CORE_FOLDER}/files/dot/ssh/${BASE_KEY_NAME}.ppk" ]]; then
            if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
                apt-get install -y putty-tools >/dev/null
            elif [ "${OS}" == 'centos' ]; then
                yum -y install putty >/dev/null
            fi

            puttygen "${VAGRANT_CORE_FOLDER}/files/dot/ssh/${BASE_KEY_NAME}" -O private -o "${VAGRANT_CORE_FOLDER}/files/dot/ssh/${BASE_KEY_NAME}.ppk"
        fi

        echo "Your private key for SSH-based authentication has been saved to 'letian/files/dot/ssh/${BASE_KEY_NAME}'!"
    else
        echo "Pre-existing private key found at 'letian/files/dot/ssh/${BASE_KEY_NAME}'"
    fi
}

### 生成key
create_key 'root_id_rsa'
create_key 'id_rsa'

# 放置公钥位置, 文件由  create_key 'id_rsa' 命令生成
PUBLIC_SSH_KEY=$(cat "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa.pub")

### 添加生成的 key 给 root 用户
echo 'Adding generated key to /root/.ssh/id_rsa'
echo 'Adding generated key to /root/.ssh/id_rsa.pub'
echo 'Adding generated key to /root/.ssh/authorized_keys'

mkdir -p /root/.ssh

cp "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa" '/root/.ssh/'
cp "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa.pub" '/root/.ssh/'

## authorized_keys 是vagrant 要求的key 文件， 这里直接通过 id_rsa.pub 来生成
if [[ ! -f '/root/.ssh/authorized_keys' ]] || ! grep -q "${PUBLIC_SSH_KEY}" '/root/.ssh/authorized_keys'; then
    cat "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa.pub" >> '/root/.ssh/authorized_keys'
fi
# linux 要求ssh 私钥的权限必须只能本人可访问.
chown -R root '/root/.ssh'
chgrp -R root '/root/.ssh'
chmod 700 '/root/.ssh'
chmod 644 '/root/.ssh/id_rsa.pub'
chmod 600 '/root/.ssh/id_rsa'
chmod 600 '/root/.ssh/authorized_keys'

# 我们如果设置的默认ssh 用户不是 root ,需要给这个用户生成key.
if [ "${VAGRANT_SSH_USERNAME}" != 'root' ]; then
    VAGRANT_SSH_FOLDER="/home/${VAGRANT_SSH_USERNAME}/.ssh";

    mkdir -p "${VAGRANT_SSH_FOLDER}"

    echo "Adding generated key to ${VAGRANT_SSH_FOLDER}/id_rsa"
    echo "Adding generated key to ${VAGRANT_SSH_FOLDER}/id_rsa.pub"
    echo "Adding generated key to ${VAGRANT_SSH_FOLDER}/authorized_keys"

    cp "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa" "${VAGRANT_SSH_FOLDER}/id_rsa"
    cp "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa.pub" "${VAGRANT_SSH_FOLDER}/id_rsa.pub"

    if [[ ! -f "${VAGRANT_SSH_FOLDER}/authorized_keys" ]] || ! grep -q "${PUBLIC_SSH_KEY}" "${VAGRANT_SSH_FOLDER}/authorized_keys"; then
        cat "${VAGRANT_CORE_FOLDER}/files/dot/ssh/id_rsa.pub" >> "${VAGRANT_SSH_FOLDER}/authorized_keys"
    fi

    chown -R "${VAGRANT_SSH_USERNAME}" "${VAGRANT_SSH_FOLDER}"
    chgrp -R "${VAGRANT_SSH_USERNAME}" "${VAGRANT_SSH_FOLDER}"
    chmod 700 "${VAGRANT_SSH_FOLDER}"
    chmod 644 "${VAGRANT_SSH_FOLDER}/id_rsa.pub"
    chmod 600 "${VAGRANT_SSH_FOLDER}/id_rsa"
    chmod 600 "${VAGRANT_SSH_FOLDER}/authorized_keys"

    passwd -d "${VAGRANT_SSH_USERNAME}" >/dev/null
fi
