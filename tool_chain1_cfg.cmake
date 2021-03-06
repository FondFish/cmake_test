set(TOOL_PREFIX /usr/KIDE/host/ide/tools_chain/powerpc/ppc64_gcc4.8.2_glibc2.18.0_multi)

SET(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_C_CREATE_STATIC_LIBRARY "<CMAKE_AR> crv <TARGET> <LINK_FLAGS> <OBJECTS>")
SET(CMAKE_C_COMPILER
    ${TOOL_PREFIX}/bin/real-gnu-gcc)
SET(CMAKE_CXX_COMPILER
    ${TOOL_PREFIX}/bin/real-gnu-g++)
set(CMAKE_ASM_COMPILER
    ${TOOL_PREFIX}/bin/real-gnu-gcc)
SET(CMAKE_FIND_ROOT_PATH  ${TOOL_PREFIX})
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


find_program(CMAKE_STRIP 
    NAMES real-gnu-strip 
    PATHS ${TOOL_PREFIX}/bin 
    NO_DEFAULT_PATH)
mark_as_advanced(CMAKE_STRIP)
