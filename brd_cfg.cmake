set(_GCOV_ENABLE    FALSE CACHE BOOL "no")
set(_PHY_BOARD      _BT_3G_VSW)
set(_LOGIC_BOARD    _LOGIC_VSW)
set(_CPU_TYPE       _CPU_T1020)
set(_CPU_SOFT_TYPE  41)
set(_VER_SOFT_TYPE  3145728)

set(_PRODUCT_TYPE   _PRODUCT_PLAT)
set(_OS_TYPE        _LINUX)
set(_PROCESS_TYPE   MGR_PROCESS)
set(_PLAT_VERSION   _L3PLAT)
set(_MODE_TYPE      _MULTI_MODE)
set(_SINGLE_PROCESS FALSE CACHE BOOL "Whether it is single process")

set(_CTRL_TYPE      _SINGLE_CTRL_)
if(_DUAL_CTRL STREQUAL _CTRL_TYPE)
    set(_SLOT_DISTRIBUTE_TYPE _Hi3G_SCENARIO)
endif()

set(_OAM_CPLUSPLUS OAM_GCCVER=300)

set(SDR_UNCOUPLE       FALSE  CACHE BOOL "Whether the process is decoupled")
set(_IS_ZEMU            FALSE CACHE BOOL "Whether this compile is for zemu")
option(SUPPORT_64BIT    "Whether current target is being run on 64bits system"  ON)
set(_TCM_MAKE           TRUE CACHE BOOL "Whether need compile TCM")
set(_L2CLK_MULTI_ENABLE FALSE CACHE BOOL "")
set(_SDR_HIDDEN_OPEN    TRUE  CACHE BOOL "")

if(_IS_ZEM)
    set(ENVIRO ZEMU)
endif()

set(_PANEL_TYPE HWM)
set(_SERVICE_TYPE SVR_HOAM)

set(_MAK_EXIST_MULTI_CPU FALSE)
set(_CURRENT_CPU_INDEX 0)
set(_MAK_DIVISION_OR_PLAT _MAK_PLAT_ONLY)

add_definitions(-DHWM_ADPATER_OAM)

################################################################################
PUB_CFGS(IT_BBU MAIN_CTRL_BOARD BOARD_REPAIR_INFO MEMERY_MODE=MEMERY_MODE_CCE)
################################################################################


################################begin OSS CFGS #################################
list(APPEND _COMM_TYPES _BOOTP _TCP _RUDP _SNMP _TIPC _OMCRUDP)
list(APPEND _DRV_TYPES _COMMON _485)

OSS_CFGS(_PATCH_TEXT_LEN_=0x10000 _PATCH_DATA_LEN_=0x10000 _PATCH_MAX_UNIT_NUM_=200 _PATCH_MAX_FUN_PER_UNIT=10)
OSS_CFGS(OSS_ADDR_MGNT_SERVER_MODE RUN_LED_DRV OSS_BBU_ENABLE OSS_TRACE_FUNC _RSP_DELAY_FUNC_ _OSS_SO_PATCH_ENABLE_ CONFIG_PATCH_AREA_IN_TEXT DBS_OP_MUTEX COMM_TCP OSS_ENABLETCPSERVER  PLATCFG_OSS_DYN_UB_ALARM_SIZE=0x4C00000 OSS_TFFS_RCY_ENABLE  SDR_UNCOUPLE OSS_ITRAN UTCA_TESTCASE_VERSION IGMP_SNP OSS_DUAL_CORE)
################################ end oss cfgs ##################################


################################ begin oam cfgs ################################
RRU_CFGS(RRU_PRM)
OAM_CFGS(_SUPPORT_MEM_VERSION _MOM_MGR AMP_ALARM_INIT OAM_NTF ALARM_LED AMP_SITE_INFO_ENABLE AMP_SUPPORTPOWEROFFALM VMP_SUPPORT_HOTPATCH )

add_definitions(-DVMP_REFACT=TRUE)

OAM_MODULES(OAM_COMMON OAM_AMP OAM_MOM OAM_MAO OAM_MAO_MGR OAM_MML OAM_COM REST_HTTP OAM_DDM OAM_DTM OAM_TMP OAM_IMP OAM_VMP OAM_CONFIG OAM_PUB OAM_LMP OAM_PICOMGR OAM_INJECTION OAM_DEPLOY SCS_SMM_ENABLE OAM_CMP)

if(_TCM_MAKE)
    if(_PROCESS_TYPE STREQUAL MGR_PROCESS)
        TCM_MODULES(TCM_OAM_ALM TCM_OAM_CFG TCM_OAM_IQCM TCM_OAM_RUCM TCM_OSS_RLCM TCM_OSS_SCS)
    endif()
endif(_TCM_MAKE)
################################## end oam cfgs ################################


############################## begin dbs cfgs ##################################
DBS_CFGS(_DBS_CENTER _DBS_MULTIPROCESS)
DBS_MODULES(DBS_APP DBS_CORE DBS_CONFIG DBS_COMMON DBS_MANAGE DBS_INTERFACE DBS_TRIGGER DBS_SYNC DBS_STAT)
################################ end dbs cfgs ##################################

################################################################################
SCS_CFGS(SCS_CMM_IT_ENABLE SCS_ABIS_CTL SCS_SON_ENABLE SCS_MSLEDDRV_ENABLE)
        #SCS_SMM_ENABLE SCS_CMM_ENABLE SCS_MSCTRL_EANBLE SCS_EPA_ENABLE NET_RATE_NEGOTIA

################################################################################
include(${PROJECT_SOURCE_DIR}/public/cmake/toolchains/compilerflags.cmake)

add_definitions(-DCPU=POWERPC)
add_definitions(-D_GNU_SOURCE
                -DTOOL=gnu
                -DCPU_FAMILY=POWERPC
                -DTOOL_FAMILY=gnu
                -D_CPU_BYTE_ORDER=_BIG_ENDIAN
                -D_REENTRANT
                -D_CURRENT_CPU_INDEX=0
                -DVERSION_NO="2.0"
                -DSDR_L3_SEPARATE_COMPILE
                -DRW_MULTI_THREAD
                -DLINUX_TESTCASE
                -D_FILE_OFFSET_BITS=64
                -DLINUX_PCI_SUPPORT
                )

add_compile_flags("-mcpu=e5500 -mhard-float -m64 -mregnames -fno-builtin")
add_compile_flags("-g")
add_compile_flags("-O0")
add_compile_flags_language("-fpermissive" "CXX")
add_compile_flags_language("-Wno-pointer-sign" "C")

set(EXE_DEPEND_LIBS bsp "-Xlinker \"-\(\" -loss -lbsp -loss -lsnmp -lscs -lbrs -ligmpsnp -lhdbs -loam -Xlinker \"-\)\" -ldl -Wl,--start-group -lpthread -lrt -lm -Wl,--end-group -static -lstdc++ -Wl,-E -Wl,--relax")

set(ALL_LINK_LIBS_DIR ${PROJECT_SOURCE_DIR}/output/lib/hwm/vsw)

set(BIN_OUTPUT_NAME_TMP MGR.EXE_tmp)
set(STRIP_OUTPUT_NAME ${PROJECT_BINARY_DIR}/MGR.EXE)
set(STRIP_EXE ${CMAKE_STRIP} --strip-debug -o ${STRIP_OUTPUT_NAME} $<TARGET_FILE:exe>)




