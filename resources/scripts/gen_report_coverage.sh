#!/bin/bash

########################################################################################################################
# 目录变量
########################################################################################################################
SCT_DIR=$(cd $(dirname $0) && pwd) # scripts
RES_DIR=$(dirname ${SCT_DIR})      # reources
PJT_DIR=$(dirname ${RES_DIR})      # repo
BLT_DIR=${PJT_DIR}/build_coverage  # build

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
cmake .. -G"Unix Makefiles" -DENABLE_TEST_COVERAGE=ON
make -j16 test_module_add
make -j16 test_module_sub
make -j16 test_module_all

########################################################################################################################
# 配置覆盖率生成环境，运行程序，生成报告
########################################################################################################################
########################################################################################################################
# test_module_add
lcov -d ./ -z                                                                                     # 初始化
${BLT_DIR}/tests/test_module_add/test_module_add 2>&1 >/dev/null                                  # 执行
lcov --rc lcov_branch_coverage=1 -c -o test_module_add.info -d .                                  # 生成覆盖率信息
lcov --rc lcov_branch_coverage=1 -e test_module_add.info "*/module_add/*" -o test_module_add.info # 过滤覆盖率信息

########################################################################################################################
# test_module_sub
lcov -d ./ -z                                                                                     # 初始化
${BLT_DIR}/tests/test_module_sub/test_module_sub 2>&1 >/dev/null                                  # 执行
lcov --rc lcov_branch_coverage=1 -c -o test_module_sub.info -d .                                  # 生成覆盖率信息
lcov --rc lcov_branch_coverage=1 -e test_module_sub.info "*/module_sub/*" -o test_module_sub.info # 过滤覆盖率信息

########################################################################################################################
# test_module_all
lcov -d ./ -z                                                                                  # 初始化
${BLT_DIR}/tests/test_module_all/test_module_all 2>&1 >/dev/null                               # 执行
lcov --rc lcov_branch_coverage=1 -c -o test_module_all.info -d .                               # 生成覆盖率信息
lcov --rc lcov_branch_coverage=1 -e test_module_all.info "*/modules/*" -o test_module_all.info # 过滤覆盖率信息

########################################################################################################################
# 转换报告到HTML形式
# 在覆盖率的正文，有该文件的完整代码，并用不同颜色进行高亮标注了：
#   - 蓝色表示运行被覆盖的代码，前面的数字表示代码执行次数
#   - 红色表示未执行代码
#   - 白色表示无效代码，包括注释，空行和未编译代码
########################################################################################################################
genhtml --rc genhtml_branch_coverage=1 test_module_add.info -o coverage_test_module_add/
genhtml --rc genhtml_branch_coverage=1 test_module_sub.info -o coverage_test_module_sub/
genhtml --rc genhtml_branch_coverage=1 test_module_all.info -o coverage_test_module_all/

########################################################################################################################
# 拷贝报告到输出目录
########################################################################################################################
# cp -r ${BLT_DIR}/coverage ${PJT_DIR}/doc/IP42_RPM_覆盖率测试报告
# cd ${PJT_DIR}/doc
# rm IP42_RPM_覆盖率测试报告.zip
# zip -rm IP42_RPM_覆盖率测试报告.zip IP42_RPM_覆盖率测试报告

########################################################################################################################
# 显示报告
########################################################################################################################
if [[ $1 == "show" ]]; then
  firefox --new-tab ${BLT_DIR}/coverage_test_module_add/index.html
  firefox --new-tab ${BLT_DIR}/coverage_test_module_sub/index.html
  firefox --new-tab ${BLT_DIR}/coverage_test_module_all/index.html
fi
