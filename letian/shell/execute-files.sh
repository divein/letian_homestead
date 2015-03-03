#!/bin/bash
# =============================================
# 执行自定义的任务：
# 任务脚本放置在 letian/files 目录下。有2种执行情景:
#  1. 每次都会执行  exec-always
#  2. 只会执行一次  exec-once
#
# @author wangxinyi <divein@126.com>
# ==============================================
export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(cat '/.letian-stuff/vagrant-core-folder.txt')
# 执行一次的脚本目录，默认是 exec-once
EXEC_ONCE_DIR="$1"
# 每次都执行的脚本目录， 默认是 exec-always
EXEC_ALWAYS_DIR="$2"

echo "Running files in files/${EXEC_ONCE_DIR}"

if [ -d "/.letian-stuff/${EXEC_ONCE_DIR}-ran" ]; then
    rm -rf "/.letian-stuff/${EXEC_ONCE_DIR}-ran"
fi

if [ ! -f "/.letian-stuff/${EXEC_ONCE_DIR}-ran" ]; then
   touch "/.letian-stuff/${EXEC_ONCE_DIR}-ran"
   echo "Created file /.puphpet-stuff/${EXEC_ONCE_DIR}-ran"
fi

# 执行once目录下所有 *.sh 文件。 使用/.letian-stuff/${EXEC_ONCE_DIR}-ran 文件来储存已经执行过的文件
find "${VAGRANT_CORE_FOLDER}/files/${EXEC_ONCE_DIR}" -maxdepth 1 -type f -name '*.sh' | sort | while read FILENAME; do
    SHA1=$(sha1sum "${FILENAME}")

    if ! grep -x -q "${SHA1}" "/.letian-stuff/${EXEC_ONCE_DIR}-ran"; then
        echo "${SHA1}" >> "/.letian-stuff/${EXEC_ONCE_DIR}-ran"

        chmod +x "${FILENAME}"
        /bin/bash "${FILENAME}"
    else
        echo "Skipping executing ${FILENAME} as contents have not changed"
    fi
done

echo "Finished running files in files/${EXEC_ONCE_DIR}"
echo "To run again, delete hashes you want rerun in /.letian-stuff/${EXEC_ONCE_DIR}-ran or the whole file to rerun all"

echo "Running files in files/${EXEC_ALWAYS_DIR}"

# 执行alway目录下所有 *.sh 文件。
find "${VAGRANT_CORE_FOLDER}/files/${EXEC_ALWAYS_DIR}" -maxdepth 1 -type f -name '*.sh' | sort | while read FILENAME; do
    chmod +x "${FILENAME}"
    /bin/bash "${FILENAME}"
done

echo "Finished running files in files/${EXEC_ALWAYS_DIR}"
