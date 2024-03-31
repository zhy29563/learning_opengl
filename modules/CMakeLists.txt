file ( GLOB SUB_FOLDERS LIST_DIRECTORIES TRUE ${CMAKE_CURRENT_SOURCE_DIR}/* )

foreach ( SUB_FOLDER ${SUB_FOLDERS} )
  if ( IS_DIRECTORY ${SUB_FOLDER} AND EXISTS ${SUB_FOLDER}/CMakeLists.txt )
    get_filename_component ( SUB_FOLDER_NAME ${SUB_FOLDER} NAME )
    add_subdirectory ( ${CMAKE_CURRENT_SOURCE_DIR}/${SUB_FOLDER_NAME} )
  endif ()
endforeach ()