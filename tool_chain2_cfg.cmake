set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_C_CREATE_STATIC_LIBRARY "<CMAKE_AR> crv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_COMPILER /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)
set(CMAKE_ASM_COMPILER /usr/bin/gcc)
set(CMAKE_FIND_ROOT_PATH  /usr)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

include_directories(SYSTEM
    /usr/include/linux/..
    /usr/lib/gcc/x86_64-linux-gnu/4.8/include
    /usr/include/linux
    /usr/include/x86_64-linux-gnu
    /usr/include/c++/4.8
    /usr/include/x86_64-linux-gnu/c++/4.8
)

find_program(CMAKE_STRIP 
    NAMES strip 
    PATHS /usr/bin 
    NO_DEFAULT_PATH)
mark_as_advanced(CMAKE_STRIP)
