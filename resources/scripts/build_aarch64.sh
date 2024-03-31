#!/bin/bash

########################################################################################################################
# 目录变量
########################################################################################################################
SCT_DIR=$(cd $(dirname $0) && pwd) # scripts
RES_DIR=$(dirname ${SCT_DIR})      # reources
PJT_DIR=$(dirname ${RES_DIR})      # repo
BLT_DIR=${PJT_DIR}/build_aarch64   # build

########################################################################################################################
# 依赖库编译环境变量
########################################################################################################################
ENVS_ROOT=${HOME}/.envs
LIBS_PATH=aarch64-none-linux-gnu-v9.2.1
LIBS_ROOT=${ENVS_ROOT}/libs/${LIBS_PATH}

########################################################################################################################
# 交叉编译工具根目录
########################################################################################################################
TLCS_ROOT=${ENVS_ROOT}/toolchains/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu

########################################################################################################################
# 编译
########################################################################################################################
echo
echo "================================================================================================================="
rm -rf "${BLT_DIR}"
mkdir -p "${BLT_DIR}" && cd "${BLT_DIR}"
cmake .. -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=${TLCS_ROOT}/toolchain.cmake
make -j16

########################################################################################################################
# 移除调试信息
########################################################################################################################
cp ${BLT_DIR}/apps/app_add/app_add ${BLT_DIR}/app_add_debug
cp ${BLT_DIR}/apps/app_sub/app_sub ${BLT_DIR}/app_sub_debug

${TLCS_ROOT}/bin/aarch64-none-linux-gnu-strip -g ${BLT_DIR}/apps/app_add/app_add -o ${BLT_DIR}/app_add
${TLCS_ROOT}/bin/aarch64-none-linux-gnu-strip -g ${BLT_DIR}/apps/app_sub/app_sub -o ${BLT_DIR}/app_sub
########################################################################################################################
# 打包输出
# tar命令
#     打包tgz：tar czvf filename.tgz files（打包并用gzip压缩）
#     解包tgz：tar xzvf filename.tgz
#
#     打包tar.gz：tar zcvf filename.tar.gz file
#     解包tar.gz：tar zxvf filename.tar.gz
#
#     打包目录：tar czvf /home/ test.tar /home/test
#             将/home/test目录打包到home目录下，如果没有指定目标目录（/home/test.tar）将打包在当前目录下
#     解包目录：tar xzvf /home/test.tar
#             解包到指定目录（C是大写）：tar -xzvf test.tar.gz -C ~
# other命令
#     压缩bzip2  ：bzip2 filename（文件会被压缩并保存为filename.bz2）
#     解压bunzip2：bunzip2 filename.bz2
#
#     压缩zip：zip –r filename.zip file
#     解压zip：unzip –o filename.zip(-o表示直接覆盖原来的文件)
#             unzip解压到指定目录unzip filename.zip –d /usr/local
########################################################################################################################
output_file="${BLT_DIR}/output.md5"
echo "build time: $(cd ${BLT_DIR} && date)" >>"${output_file}"
echo "git hash  : $(cd ${PJT_DIR} && git rev-parse HEAD)" >>"${output_file}"

echo "md5 value : $(cd ${BLT_DIR} && md5sum app_add)" >>"${output_file}"
echo "md5 value : $(cd ${BLT_DIR} && md5sum app_add_debug)" >>"${output_file}"
echo "md5 value : $(cd ${BLT_DIR} && md5sum app_sub)" >>"${output_file}"
echo "md5 value : $(cd ${BLT_DIR} && md5sum app_sub_debug)" >>"${output_file}"

echo "cks value : $(cd ${BLT_DIR} && cksum app_add)" >>"${output_file}"
echo "cks value : $(cd ${BLT_DIR} && cksum app_add_debug)" >>"${output_file}"
echo "cks value : $(cd ${BLT_DIR} && cksum app_sub)" >>"${output_file}"
echo "cks value : $(cd ${BLT_DIR} && cksum app_sub_debug)" >>"${output_file}"

tar -zcvf output.tar.gz app_add app_add_debug app_sub app_sub_debug output.md5

########################################################################################################################
# 结束
########################################################################################################################
pwd
echo "================================================================================================================="
echo
