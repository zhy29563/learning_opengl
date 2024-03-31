# ######################################################################################################################
# 自动配置子项目名称
# 子项目可以有自己的版本号
# ######################################################################################################################
cmake_minimum_required ( VERSION ${CMAKE_MINIMUM_REQUIRED_VERSION} )
get_filename_component ( FOLDER_PATH ${CMAKE_CURRENT_LIST_FILE} DIRECTORY )
get_filename_component ( PARENT_PATH ${FOLDER_PATH} DIRECTORY )
get_filename_component ( FOLDER_NAME ${FOLDER_PATH} NAME )
get_filename_component ( PARENT_NAME ${PARENT_PATH} NAME )
project ( ${PARENT_NAME}-${FOLDER_NAME} )

# ######################################################################################################################
# 全局依赖
# ######################################################################################################################
# module_add
set ( ENV{PKG_CONFIG_PATH} ${CMAKE_INSTALL_PREFIX}/module_add/lib/pkgconfig )
pkg_search_module ( LIB_MODULE_ADD REQUIRED module_add )

if ( ${LIB_MODULE_ADD_FOUND} )
  DEBUG_PRINT_VARS_WITH_REGEX ( "LIB_MODULE_ADD" )
  include_directories ( ${LIB_MODULE_ADD_INCLUDE_DIRS} )
  link_directories ( ${LIB_MODULE_ADD_LIBRARY_DIRS} )
  link_libraries ( ${LIB_MODULE_ADD_LIBRARIES} )
else ()
  message ( FATAL_ERROR "Can not found module_add" )
endif ()

# ######################################################################################################################
# 目标
# ######################################################################################################################
file ( GLOB_RECURSE INC_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h* )
file ( GLOB_RECURSE SRC_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/sources/*.c* )

add_executable ( ${FOLDER_NAME} EXCLUDE_FROM_ALL ${INC_FILES} ${SRC_FILES} )

# ######################################################################################################################
# 目标配置
# ######################################################################################################################
target_include_directories ( ${FOLDER_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include )
target_link_libraries ( ${FOLDER_NAME} PRIVATE ${TARGET-module_add} )
add_dependencies ( ${FOLDER_NAME} ${TARGET-module_add} )