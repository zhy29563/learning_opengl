#!/bin/bash
# 需要管理员权限运行

########################################################################################################################
# 目录变量
########################################################################################################################
SCT_DIR=$(cd $(dirname $0) && pwd) # scripts
RES_DIR=$(dirname ${SCT_DIR})      # reources
PJT_DIR=$(dirname ${RES_DIR})      # repo
BLT_DIR=${PJT_DIR}/build_cpu_perf  # build

########################################################################################################################
# 依赖库编译环境变量
########################################################################################################################
ENVS_ROOT=${HOME}/.envs
LIBS_PATH=x86_64-linux-gnu-v9.4.0
LIBS_ROOT=${ENVS_ROOT}/libs/${LIBS_PATH}

########################################################################################################################
# 编译
########################################################################################################################
rm -rf "${BLT_DIR}"
mkdir -p "${BLT_DIR}" && cd "${BLT_DIR}"
cmake .. -G"Unix Makefiles" -DENABLE_TEST_CPU_PROF=ON
make -j16
########################################################################################################################
# 运行测试程序并生成报告
########################################################################################################################
unzip ${RES_DIR}/tools/FlameGraph-master.zip

pkill app_add

${BLT_DIR}/apps/app_add/app_add &
echo "pid of app_add = $(pidof app_add)"
sudo perf record --call-graph dwarf,4096 --event=cpu-clock --freq=max --pid=`pidof app_add` --output=perf_app_add.data &
ps -ef | grep perf

# 程序运行时间
sleep 10
echo "pid of perf = $(pidof perf)"
kill -2 `pidof perf`
# 等待数据成功写入文件
sleep 10

sudo perf script -i perf_app_add.data > perf_app_add.perf
./FlameGraph-master/stackcollapse-perf.pl perf_app_add.perf > perf_app_add.folded
./FlameGraph-master/flamegraph.pl perf_app_add.folded > app_add_flame_graph.svg