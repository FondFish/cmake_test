macro(add_asm_files _target)
    list(APPEND ${_target} ${ARGN})
endmacro()
# add_compile_flags
# add_compile_flags_language
# replace_compile_flags
# replace_compile_flags_language
#  Add or replace compiler flags in the global scope for either all source
#  files or only those of the specified language.
# Examples:
#  add_compile_flags("-pedantic -O5")
#  add_compile_flags_language("-std=gnu99" "C")
#  replace_compile_flags("-O5" "-O3")
#  replace_compile_flags_language("-fno-exceptions" "-fexceptions" "CXX")
function(add_compile_flags _flags)
    if(${ARGC} GREATER 1)
        message(FATAL_ERROR "Excess arguments to add_compile_flags! Args ${ARGN}")
    endif()
    # Adds the compiler flag for all code files: C, C++, and assembly
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_flags}" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_flags}" PARENT_SCOPE)
    set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${_flags}" PARENT_SCOPE)
endfunction()

function(add_compile_flags_language _flags _lang)
    if(NOT ${ARGC} EQUAL 2)
        message(FATAL_ERROR "Wrong arguments to add_compile_flags_language! Args ${ARGN}")
    endif()
    # Adds the compiler flag for the specified language only, e.g. CMAKE_C_FLAGS
    set(CMAKE_${_lang}_FLAGS "${CMAKE_${_lang}_FLAGS} ${_flags}" PARENT_SCOPE)
endfunction()

macro(replace_compile_flags _oldflags _newflags)
    if(NOT ${ARGC} EQUAL 2)
        message(FATAL_ERROR "Wrong arguments to replace_compile_flags! Args ${ARGN}")
    endif()
    replace_compiler_option(CMAKE_C_FLAGS ${_oldflags} ${_newflags})
    replace_compiler_option(CMAKE_CXX_FLAGS ${_oldflags} ${_newflags})
    replace_compiler_option(CMAKE_ASM_FLAGS ${_oldflags} ${_newflags})
endmacro()

macro(replace_compile_flags_language _oldflags _newflags _lang)
    if(NOT ${ARGC} EQUAL 3)
        message(FATAL_ERROR "Wrong arguments to replace_compile_flags_language! Args ${ARGN}")
    endif()
    replace_compiler_option(CMAKE_${_lang}_FLAGS ${_oldflags} ${_newflags})
endmacro()

function(add_link_flags _flags)
    if(${ARGC} GREATER 1)
        message(FATAL_ERROR "Excess arguments to add_link_flags! Args ${ARGN}")
    endif()
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${_flags}" PARENT_SCOPE)
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${_flags}" PARENT_SCOPE)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${_flags}" PARENT_SCOPE)
endfunction()

function(add_target_link_flags _module _flags)
    if(${ARGC} GREATER 2)
        message(FATAL_ERROR "Excess arguments to add_target_link_flags! Module ${_module}, args ${ARGN}")
    endif()
    add_target_property(${_module} LINK_FLAGS ${_flags})
endfunction()

function(add_short_file_define _src_list)
    foreach(each ${_src_list})
        get_filename_component(SHORT_FILE_NAME ${each} NAME)
        get_source_file_property(OLD_PROPS ${each} COMPILE_FLAGS)

        if(NOT OLD_PROPS STREQUAL NOTFOUND)
            set_source_files_properties(${each}
            PROPERTIES
            COMPILE_FLAGS
            "-D__SHORT_FILE__=\\\"${SHORT_FILE_NAME}\\\" ${OLD_PROPS}")
        else()
            set_source_files_properties(${each}
            PROPERTIES
            COMPILE_FLAGS "-D__SHORT_FILE__=\\\"${SHORT_FILE_NAME}\\\"")
        endif()
    endforeach()
endfunction()


if(GCOV_ENABLE)
    add_link_flags("-lgcov")
endif()

if(SUPPORT_64BIT)
    set(GCC_PARA "64")
else()
    set(GCC_PARA "32")
endif()

if(SUPPORT_64BIT)
    add_definitions(-DSUPPORT_64BIT)
endif()

add_definitions(
                -D_CPU_TYPE=${_CPU_TYPE}
                -D_LOGIC_BOARD=${_LOGIC_BOARD}
                )

if(_VERSION_NO)
    add_definitions(-DVERSION_NO=${_VERSION_NO})
endif()

if(_PRODUCT_TYPE)
    add_definitions(-D_PRODUCT_TYPE=${_PRODUCT_TYPE})
endif()

if(_CPU_BYTE_ORDER)
    add_definitions(-D_CPU_BYTE_ORDER=${_CPU_BYTE_ORDER})
endif()

if(DEFINED _CURRENT_CPU_INDEX)
    add_definitions(-D_CURRENT_CPU_INDEX=${_CURRENT_CPU_INDEX})
endif()

if(_MODE_TYPE)
    add_definitions(-D_MODE_TYPE=${_MODE_TYPE})
endif()

if(TestTool)
    add_definitions(-DTestTool=${TestTool})
endif()

if(_OAM_CPLUSPLUS)
    add_definitions(-D${_OAM_CPLUSPLUS})
endif()

if(_SERVICE_TYPE)
    add_definitions(-D${_SERVICE_TYPE})
endif()

if(_PANEL_TYPE)
    add_definitions(-D${_PANEL_TYPE})
endif()

if(_PRODUCT_MULTI)
    add_definitions(-D_PRODUCT_MULTI=${_PRODUCT_MULTI})
endif()

if(SDR_UNCOUPLE STREQUAL TRUE)
    add_definitions(-DSDR_UNCOUPLE)
endif()

if(_MEM_CHECK_SURPORT)
    add_definitions(-DMEM_CHECK_SURPORT)
    set(MEM_CHECK_OPT -kmt_slop_all)
    add_definitions(-DMEM_CHECK_OPT=${MEM_CHECK_OPT})
endif()

if(_MEM_LEAK_SURPORT)
    add_definitions(-DMEM_CHECK_SURPORT)
    set(MEM_CHECK_OPT -kmt_leak)
    add_definitions(-DMEM_CHECK_OPT=${MEM_CHECK_OPT})
endif()

if(_DUAL_CTRL AND _CTRL_TYPE)
    if("${_DUAL_CTRL}" STREQUAL "${_CTRL_TYPE}")
        add_definitions(
            -D_CTRL_TYPE=${_CTRL_TYPE}
            -D_SLOT_DISTRIBUTE_TYPE=${_SLOT_DISTRIBUTE_TYPE}
            )
    endif()
endif()

if(_OS_TYPE STREQUAL "_VXWORKS")
    add_definitions(-DVOS_VXWORKS)
endif()

if(_PLAT_VERSION STREQUAL "_L3PLAT")
    FIND_VAR_FROM_LIST(RRU_CFGS RRU_PRM)
    if(RRU_PRM_FOUND)
        add_definitions(-DRRU_PRM_ENABLE)
    endif()

    add_definitions(
        -D_PLAT_VERSION=${_PLAT_VERSION}
        -DSDR_L3_ENABLE
    )

    if(_OS_TYPE STREQUAL "_LINUX")
        if(_SINGLE_PROCESS)
            add_definitions(-DSDR_L3_TOGETHER_COMPILE)
        endif()
    endif()
endif()



if(_SINGLE_PROCESS)
    add_definitions(-DSINGLE_PROCESS)
endif()

if(TESTCASE_VERSION)
    add_definitions(-DPLAT_TESTCASE_VERSION)
endif()

if(TEST_BSCPCF_VERSION)
    add_definitions(-DPLAT_BSCPCF_VERSION)
endif()

if(ITRAN_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DDEBUG_VERSION)
else()
    add_definitions(-DRELEASE_VERSION)
endif()

if(_OS_TYPE STREQUAL "_VXWORKS")
    if(ITRAN_BUILD_TYPE STREQUAL "Release")
       add_definitions(-DOSS_SYS_MALLOC_PROTECT_SWITCH)
    endif()
endif()

if(_PROCESSOR_NET_TYPE)
    add_definitions(-D_PROCESSOR_NET_TYPE=${_PROCESSOR_NET_TYPE})
else()
    add_definitions(-D_PROCESSOR_NET_TYPE=0)
endif()

if(_MAK_WITHOUT_SUBSYS)
    add_definitions(-D_MAK_WITHOUT_SUBSYS=${_MAK_WITHOUT_SUBSYS})
else()
    add_definitions(-D_MAK_WITHOUT_SUBSYS=0)
endif()

if(_OS_TYPE STREQUAL "_LINUX")
    add_definitions(
        -DVOS_LINUX
        -D${_PROCESS_TYPE}
        )
    if(_SDR_UNCOUPLE)
        add_definitions(-DSDR_UNCOUPLE)
    endif()
endif()



