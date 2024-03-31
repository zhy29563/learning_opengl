# ######################################################################################################################
# 帮助
# ######################################################################################################################

# ######################################################################################################################
# 项目设置
# ######################################################################################################################
cmake_minimum_required ( VERSION 3.16 FATAL_ERROR )
get_filename_component ( PROJECT_FOLDER_PATH ${CMAKE_CURRENT_LIST_FILE} PATH )
get_filename_component ( PROJECT_FOLDER_NAME ${PROJECT_FOLDER_PATH} NAME )
project ( ${PROJECT_FOLDER_NAME} VERSION 1.0.0.0 )

# ######################################################################################################################
# 导入
# ######################################################################################################################
include ( GNUInstallDirs )
include ( FindPkgConfig )
include ( CMakeDependentOption )
include ( CMakePackageConfigHelpers )
include ( resources/cmake/debug_marco.cmake )

# ######################################################################################################################
# 编译配置
# ######################################################################################################################
# 90(C89/C90) 99(C99) 11(C11) 17(C17)[V3.21] 23(C23)[V3.21]
set ( CMAKE_C_STANDARD 11 )
set ( CMAKE_C_STANDARD_REQUIRED TRUE )
set ( CMAKE_C_EXTENSIONS TRUE )

# 98(C++98) 11(C++11) 14(C++14) 17(C++17)[V3.8] 20(C++20)[V3.12] 23(C++23)[V3.20] 26(C++26)[V3.25]
set ( CMAKE_CXX_STANDARD 11 )
set ( CMAKE_CXX_STANDARD_REQUIRED TRUE )
set ( CMAKE_CXX_EXTENSIONS TRUE )

set ( CMAKE_INCLUDE_CURRENT_DIR TRUE )
set ( CMAKE_POSITION_INDEPENDENT_CODE TRUE )
set ( CMAKE_EXPORT_COMPILE_COMMANDS TRUE )
set ( CMAKE_VERBOSE_MAKEFILE TRUE )

if ( NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES )
  set ( CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE )
  set_property ( CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo" )
endif ()

# ######################################################################################################################
# 安装配置
# ######################################################################################################################
if ( NOT ${CMAKE_INSTALL_PREFIX} )
  set ( CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/outputs )
endif ()

# ######################################################################################################################
# 编译选项
# ######################################################################################################################
option ( ENABLE_FUNCTION_QT "Build Qt projects" OFF )
option ( ENABLE_TEST_UNITTEST "Enable unittest based on googletest" OFF )
option ( ENABLE_TEST_COVERAGE "Enable coverage based on lcov and gcov" OFF )
option ( ENABLE_TEST_HEAP_GPERFTOOLS "Enable memory analysis based on gpeerftools" OFF )
option ( ENABLE_TEST_HEAP_VALGRIND "Enable memory analysis based on valgrind" OFF )
option ( ENABLE_TEST_CPU_GPERFTOOLS "Enable CPU performace analysis based on gpeerftools" OFF )
option ( ENABLE_TEST_CPU_GPROF "Enable CPU performace analysis based on gprof" OFF )
option ( ENABLE_TEST_CPU_PROF "Enable CPU performace analysis based on perf" OFF )

add_compile_options ( -Wall ) # 开启所有常规警告
add_compile_options ( -Wextra ) # 开启额外警告

# add_compile_options ( -w )  # 关闭所有警告
# add_compile_options ( -Wno-error=deprecated-declarations )
# add_compile_options ( -Wno-deprecated-declarations )
# add_compile_options ( -Wunused-parameter )
if ( ${ENABLE_TEST_COVERAGE} )
  # 要开启gcov功能，需要在源码编译参数中加入-fprofile-arcs -ftest-coverage
  # -ftest-coverage：在编译的时候产生.gcno文件，它包含了重建基本块图和相应的块的源码的行号的信息。
  # -fprofile-arcs ：在运行编译过的程序的时候，会产生.gcda文件，它包含了弧跳变的次数等信息。
  set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage" )
  set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage" )
  link_libraries ( gcov )
endif ()

if ( ${ENABLE_TEST_CPU_GPERFTOOLS} )
  add_compile_definitions ( ENABLE_TEST_CPU_GPERFTOOLS )
endif ()

if ( ${ENABLE_TEST_HEAP_GPERFTOOLS} )
  add_compile_definitions ( ENABLE_TEST_HEAP_GPERFTOOLS )
endif ()

if ( ${ENABLE_TEST_CPU_GPROF} )
  add_compile_definitions ( ENABLE_TEST_CPU_GPROF )
  set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg" )
  set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg" )
endif ()

if ( ${ENABLE_TEST_CPU_PROF} )
  add_compile_definitions ( ENABLE_TEST_CPU_PROF )
endif ()

if ( ${ENABLE_TEST_HEAP_VALGRIND} )
  add_compile_definitions ( ENABLE_TEST_HEAP_VALGRIND )
  set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g" )
  set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g" )
endif ()

if ( ${CMAKE_CROSSCOMPILING} )
  set ( ENABLE_FUNCTION_QT OFF CACHE BOOL "Build Qt projects" FORCE )
endif ()

# ######################################################################################################################
# RPATH
# ######################################################################################################################
set ( CMAKE_SKIP_RPATH OFF )
set ( CMAKE_SKIP_BUILD_RPATH OFF )
set ( CMAKE_SKIP_INSTALL_RPATH OFF )
set ( CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -Wl,-disable-new-dtags" )

if ( ${CMAKE_CROSSCOMPILING} )
  set ( CMAKE_BUILD_RPATH "" )
endif ()

# ######################################################################################################################
# 设置依赖库变量
# ######################################################################################################################
set ( ENVS_ROOT $ENV{HOME}/.envs )
set ( LIBS_NAME ${CMAKE_LIBRARY_ARCHITECTURE}-v${CMAKE_C_COMPILER_VERSION} )
set ( LIBS_ROOT ${ENVS_ROOT}/libs/${LIBS_NAME} )
message ( STATUS "LIBS_ROOT   = ${LIBS_ROOT} " )

# ######################################################################################################################
# 第三方依赖
# ######################################################################################################################
# pkg-config
if ( ${PKG_CONFIG_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "PKG_CONFIG" )
else ()
  message ( FATAL_ERROR " Can not found pkgconfig, please install it by using sudo apt install pkg-config " )
endif ()

# ######################################################################################################################
# QT5
if ( ${ENABLE_FUNCTION_QT} )
  set ( CMAKE_PREFIX_PATH $ENV{HOME}/Apps/Qt/5.12.8/gcc_64 ) # 根据实际路径指定
  find_package ( Qt5 REQUIRED COMPONENTS Core Widgets Gui Xml OpenGL )

  if ( ${Qt5_FOUND} )
    DEBUG_PRINT_VARS_WITH_REGEX ( "Qt5" )
  else ()
    message ( FATAL_ERROR "Can not found Qt5" )
  endif ()
endif ()

# ######################################################################################################################
# EIGEN3
set ( ENV{PKG_CONFIG_PATH} ${LIBS_ROOT}/libeigen-3.4.0/share/pkgconfig )
pkg_search_module ( LIB_EIGEN3 REQUIRED eigen3 )

if ( ${LIB_EIGEN3_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_EIGEN3" )
else ()
  message ( FATAL_ERROR "Can not found Eigen3" )
endif ()

# ######################################################################################################################
# FREEGLUT
set ( ENV{PKG_CONFIG_PATH} ${LIBS_ROOT}/libfreeglut-3.4.0/lib/pkgconfig )
pkg_search_module ( LIB_FREEGLUT REQUIRED glut )

if ( ${LIB_FREEGLUT_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_FREEGLUT" )
else ()
  message ( FATAL_ERROR "Can not found freeglut" )
endif ()

# ######################################################################################################################
# OPENCV
set ( ENV{PKG_CONFIG_PATH} ${LIBS_ROOT}/libopencv-3.4.5/lib/pkgconfig )
pkg_search_module ( LIB_OPENCV REQUIRED opencv )

if ( ${LIB_OPENCV_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_OPENCV" )
else ()
  message ( FATAL_ERROR "Can not found opencv" )
endif ()

# ######################################################################################################################
# SPDLOG
set ( ENV{PKG_CONFIG_PATH} ${LIBS_ROOT}/libspdlog-1.12.0/lib/pkgconfig )
pkg_search_module ( LIB_SPDLOG REQUIRED spdlog )

if ( ${LIB_SPDLOG_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_SPDLOG" )
  include_directories ( ${LIB_SPDLOG_INCLUDE_DIRS} )
  link_directories ( ${LIB_SPDLOG_LIBRARY_DIRS} )
  link_libraries ( ${LIB_SPDLOG_LIBRARIES} )
else ()
  message ( FATAL_ERROR "Can not found spdlog" )
endif ()

# ######################################################################################################################
# GTEST
set ( ENV{PKG_CONFIG_PATH} ${LIBS_ROOT}/libgtest-1.12.1/lib/pkgconfig )
pkg_search_module ( LIB_GTEST REQUIRED gtest )

if ( ${LIB_GTEST_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_GTEST" )
else ()
  message ( FATAL_ERROR "Can not found gtest" )
endif ()

# ######################################################################################################################
# LIBUNWIND
if ( ${ENABLE_TEST_CPU_GPERFTOOLS} OR ${ENABLE_TEST_HEAP_GPERFTOOLS} )
  set ( ENV{PKG_CONFIG_PATH} "${LIBS_ROOT}/libunwind-1.6.2/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}" )
  pkg_search_module ( LIB_UNWIND REQUIRED libunwind )

  if ( ${LIB_UNWIND_FOUND} )
    DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_UNWIND" )
  endif ()
endif ()

# ######################################################################################################################
# LIBPROFILER
if ( ${ENABLE_TEST_CPU_GPERFTOOLS} )
  set ( ENV{PKG_CONFIG_PATH} "${LIBS_ROOT}/libgperftools-2.10/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}" )
  pkg_search_module ( LIB_GPTS_CPU REQUIRED libprofiler )

  if ( ${LIB_GPTS_CPU_FOUND} )
    DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_GPTS_CPU" )
  endif ()
endif ()

# ######################################################################################################################
# LIBTCMALLOC
if ( ${ENABLE_TEST_HEAP_GPERFTOOLS} )
  set ( ENV{PKG_CONFIG_PATH} "${LIBS_ROOT}/libgperftools-2.10/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}" )
  pkg_search_module ( LIB_GPTS_HEAP REQUIRED libtcmalloc )

  if ( ${LIB_GPTS_HEAP_FOUND} )
    DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_GPTS_HEAP" )
  endif ()
endif ()

# ######################################################################################################################
# GMOCK
set ( ENV{PKG_CONFIG_PATH} ${LIBS_ROOT}/libgtest-1.12.1/lib/pkgconfig )
pkg_search_module ( LIB_GMOCK REQUIRED gmock )

if ( ${LIB_GMOCK_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_GMOCK" )
else ()
  message ( FATAL_ERROR "Can not found gmock" )
endif ()

# ######################################################################################################################
# 子项目
# ######################################################################################################################
add_subdirectory ( modules )
add_subdirectory ( apps )

if ( ${ENABLE_TEST_UNITTEST} )
  add_subdirectory ( tests )
endif ()

# ######################################################################################################################
# 资源
# ######################################################################################################################
# file ( COPY ${CMAKE_SOURCE_DIR}/resources DESTINATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} )
# if ( NOT EXISTS ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/plugins/ )
# file ( MAKE_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/plugins )
# endif ()
