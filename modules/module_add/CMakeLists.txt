# ######################################################################################################################
# 自动配置子项目名称
# 子项目可以有自己的版本号
# ######################################################################################################################
cmake_minimum_required ( VERSION ${CMAKE_MINIMUM_REQUIRED_VERSION} )
get_filename_component ( FOLDER_PATH ${CMAKE_CURRENT_LIST_FILE} DIRECTORY )
get_filename_component ( PARENT_PATH ${FOLDER_PATH} DIRECTORY )
get_filename_component ( FOLDER_NAME ${FOLDER_PATH} NAME )
get_filename_component ( PARENT_NAME ${PARENT_PATH} NAME )
project ( ${PARENT_NAME}-${FOLDER_NAME} VERSION 1.1.1.1 )

# ######################################################################################################################
# 全局依赖
# ######################################################################################################################
if ( ${Qt5_FOUND} )
  link_libraries ( ${Qt5Gui_LIBRARIES} )
  link_libraries ( ${Qt5Xml_LIBRARIES} )
  link_libraries ( ${Qt5Core_LIBRARIES} )
  link_libraries ( ${Qt5OpenGL_LIBRARIES} )
  link_libraries ( ${Qt5Widgets_LIBRARIES} )
  set ( CMAKE_AUTOUIC ON )
  set ( CMAKE_AUTOMOC ON )
  set ( CMAKE_AUTORCC ON )
  list ( APPEND CMAKE_AUTOUIC_SEARCH_PATHS "${CMAKE_CURRENT_SOURCE_DIR}/uis" )
endif ()

# ######################################################################################################################
# 目标
# ######################################################################################################################
file ( GLOB_RECURSE INC_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h* )
file ( GLOB_RECURSE SRC_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/sources/*.c* )

if ( ${Qt5_FOUND} )
  file ( GLOB_RECURSE TSS_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/*.ts )
  file ( GLOB_RECURSE QRC_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/*.qrc )
  file ( GLOB_RECURSE UIS_FILES LIST_DIRECTORIES FALSE ${CMAKE_CURRENT_SOURCE_DIR}/uis/*.ui )
endif ()

add_library ( ${FOLDER_NAME} ${TSS_FILES} ${QRC_FILES} ${UIS_FILES} ${INC_FILES} ${SRC_FILES} )

# ######################################################################################################################
# 目标配置
# ######################################################################################################################
target_include_directories ( ${FOLDER_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include )

# target_link_libraries ( ${FOLDER_NAME} PRIVATE ${TARGET-XXX} ) # 添加工程内生成的依赖库
# add_dependencies ( ${FOLDER_NAME} ${TARGET-XXX} ) # 工程内依赖库的依赖关系

# ######################################################################################################################
# 设置库的名称到缓存变量，以便其他程序使用
# ######################################################################################################################
set ( TARGET-${FOLDER_NAME} ${FOLDER_NAME} CACHE STRING "The target name of ${FOLDER_NAME} module" FORCE )

# ######################################################################################################################
# 参考：https://blog.csdn.net/qq_38410730/article/details/102837401
# ######################################################################################################################
# 库与可执行文件
install ( TARGETS ${FOLDER_NAME}
  RUNTIME DESTINATION ${FOLDER_NAME}/${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${FOLDER_NAME}/${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${FOLDER_NAME}/${CMAKE_INSTALL_LIBDIR} )

# 头文件
set ( INSTALL_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/include/add.h )
install ( FILES ${INSTALL_HEADER} DESTINATION ${FOLDER_NAME}/${CMAKE_INSTALL_INCLUDEDIR} )

# 配置文件
configure_file ( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/${FOLDER_NAME}.pc.in ${CMAKE_CURRENT_BINARY_DIR}/cmake/${FOLDER_NAME}.pc @ONLY )
install ( FILES ${CMAKE_CURRENT_BINARY_DIR}/cmake/${FOLDER_NAME}.pc DESTINATION ${FOLDER_NAME}/${CMAKE_INSTALL_LIBDIR}/pkgconfig )