file ( GLOB SUB_FOLDERS LIST_DIRECTORIES TRUE ${CMAKE_CURRENT_SOURCE_DIR}/* )

# ######################################################################################################################
# 全局依赖
# ######################################################################################################################
if ( ${LIB_GTEST_FOUND} )
  include_directories ( ${LIB_GTEST_INCLUDE_DIRS} )
  link_directories ( ${LIB_GTEST_LIBRARY_DIRS} )
  link_libraries ( ${LIB_GTEST_LIBRARIES} )
endif ()

if ( ${LIB_GMOCK_FOUND} )
  include_directories ( ${LIB_GMOCK_INCLUDE_DIRS} )
  link_directories ( ${LIB_GMOCK_LIBRARY_DIRS} )
  link_libraries ( ${LIB_GMOCK_LIBRARIES} )
endif ()

# ######################################################################################################################
# 子项目
# ######################################################################################################################
foreach ( SUB_FOLDER ${SUB_FOLDERS} )
  if ( IS_DIRECTORY ${SUB_FOLDER} AND EXISTS ${SUB_FOLDER}/CMakeLists.txt )
    get_filename_component ( SUB_FOLDER_NAME ${SUB_FOLDER} NAME )
    add_subdirectory ( ${CMAKE_CURRENT_SOURCE_DIR}/${SUB_FOLDER_NAME} )
  endif ()
endforeach ()