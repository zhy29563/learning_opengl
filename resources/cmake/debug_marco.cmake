# 输出集合变量的值
MACRO ( PRINT_VARS VARS_NAME )
  message ( STATUS "=================================================================================================" )

  foreach ( _var ${${VARS_NAME}} )
    message ( STATUS ${VARS_NAME}=${_var} )
  endforeach ()
ENDMACRO ()

# 输出当前目录下的所有变量
MACRO ( DEBUG_PRINT_VARS )
  message ( STATUS "=================================================================================================" )
  get_property ( _vars DIRECTORY PROPERTY VARIABLES )

  foreach ( _var ${_vars} )
    message ( STATUS ${_var}=${${_var}} )
  endforeach ()
ENDMACRO ()

# 输出当前目录下与指定正则表达式匹配的变量
MACRO ( DEBUG_PRINT_VARS_WITH_REGEX _regex )
  message ( STATUS "=================================================================================================" )
  get_property ( _vars DIRECTORY PROPERTY VARIABLES )

  foreach ( _var ${_vars} )
    if ( _var MATCHES "${_regex}" )
      message ( STATUS ${_var}=${${_var}} )
    endif ()
  endforeach ()
ENDMACRO ()
