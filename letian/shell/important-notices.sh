#!/bin/bash
# =============================================
# 最后用来显示提示信息。
#
# @author wangxinyi <divein@126.com>
# ==============================================
VAGRANT_CORE_FOLDER=$(cat '/.letian-stuff/vagrant-core-folder.txt')

if [[ -f '/.letian-stuff/displayed-important-notices' ]]; then
    exit 0
fi

cat "${VAGRANT_CORE_FOLDER}/shell/ascii-art/important-notices.txt"

touch '/.letian-stuff/displayed-important-notices'
