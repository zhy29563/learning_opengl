# ######################################################################################################################
# 自动配置子项目名称
# 子项目可以有自己的版本号
# ######################################################################################################################
cmake_minimum_required ( VERSION ${CMAKE_MINIMUM_REQUIRED_VERSION} )
get_filename_component ( FOLDER_PATH ${CMAKE_CURRENT_LIST_FILE} DIRECTORY )
get_filename_component ( PARENT_PATH ${FOLDER_PATH} DIRECTORY )
get_filename_component ( FOLDER_NAME ${FOLDER_PATH} NAME )
get_filename_component ( PARENT_NAME ${PARENT_PATH} NAME )
project ( ${PARENT_NAME}-${FOLDER_NAME} VERSION 1.0.0.0 )

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

if ( ${LIB_FREEGLUT_FOUND} )
  include_directories ( ${LIB_FREEGLUT_INCLUDE_DIRS} )
  link_directories ( ${LIB_FREEGLUT_LIBRARY_DIRS} )
  link_libraries ( ${LIB_FREEGLUT_LIBRARIES} GL )
endif ()

if ( ${LIB_OPENCV_FOUND} )
  include_directories ( ${LIB_OPENCV_INCLUDE_DIRS} )
  link_directories ( ${LIB_OPENCV_LIBRARY_DIRS} )
  link_libraries ( ${LIB_OPENCV_LIBRARIES} )
endif ()

if ( ${LIB_UNWIND_FOUND} )
  include_directories ( ${LIB_UNWIND_INCLUDE_DIRS} )
  link_directories ( ${LIB_UNWIND_LIBRARY_DIRS} )
  link_libraries ( ${LIB_UNWIND_LIBRARIES} )
endif ()

if ( ${LIB_GPTS_CPU_FOUND} )
  include_directories ( ${LIB_GPTS_CPU_INCLUDE_DIRS} )
  link_directories ( ${LIB_GPTS_CPU_LIBRARY_DIRS} )
  link_libraries ( ${LIB_GPTS_CPU_LIBRARIES} )
endif ()

if ( ${LIB_GPTS_HEAP_FOUND} )
  include_directories ( ${LIB_GPTS_HEAP_INCLUDE_DIRS} )
  link_directories ( ${LIB_GPTS_HEAP_LIBRARY_DIRS} )
  link_libraries ( ${LIB_GPTS_HEAP_LIBRARIES} )
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

add_executable ( ${FOLDER_NAME} ${TSS_FILES} ${QRC_FILES} ${UIS_FILES} ${INC_FILES} ${SRC_FILES} )

# ######################################################################################################################
# 目标配置
# ######################################################################################################################
target_include_directories ( ${FOLDER_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include )
target_link_libraries ( ${FOLDER_NAME} PRIVATE ${TARGET-module_add} )
add_dependencies ( ${FOLDER_NAME} ${TARGET-module_add} )