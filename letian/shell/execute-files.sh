#!/bin/bash
# =============================================
# ִ���Զ��������
# ����ű������� letian/files Ŀ¼�¡���2��ִ���龰:
#  1. ÿ�ζ���ִ��  exec-always
#  2. ֻ��ִ��һ��  exec-once
#
# @author wangxinyi <divein@126.com>
# ==============================================
export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(cat '/.letian-stuff/vagrant-core-folder.txt')
# ִ��һ�εĽű�Ŀ¼��Ĭ���� exec-once
EXEC_ONCE_DIR="$1"
# ÿ�ζ�ִ�еĽű�Ŀ¼�� Ĭ���� exec-always
EXEC_ALWAYS_DIR="$2"

echo "Running files in files/${EXEC_ONCE_DIR}"

if [ -d "/.letian-stuff/${EXEC_ONCE_DIR}-ran" ]; then
    rm -rf "/.letian-stuff/${EXEC_ONCE_DIR}-ran"
fi

if [ ! -f "/.letian-stuff/${EXEC_ONCE_DIR}-ran" ]; then
   touch "/.letian-stuff/${EXEC_ONCE_DIR}-ran"
   echo "Created file /.puphpet-stuff/${EXEC_ONCE_DIR}-ran"
fi

# ִ��onceĿ¼������ *.sh �ļ��� ʹ��/.letian-stuff/${EXEC_ONCE_DIR}-ran �ļ��������Ѿ�ִ�й����ļ�
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

# ִ��alwayĿ¼������ *.sh �ļ���
find "${VAGRANT_CORE_FOLDER}/files/${EXEC_ALWAYS_DIR}" -maxdepth 1 -type f -name '*.sh' | sort | while read FILENAME; do
    chmod +x "${FILENAME}"
    /bin/bash "${FILENAME}"
done

echo "Finished running files in files/${EXEC_ALWAYS_DIR}"
