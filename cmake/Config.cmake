# detect the OS
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(DESIGNAR_OS_UNIX 1)
    set(DESIGNAR_OS_LINUX 1)
else()
    message(FATAL_ERROR "Unsupported operating system or environment")
    return()
endif()

# detect the compiler and its version
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(DESIGNAR_COMPILER_CLANG 1)

    execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "--version" OUTPUT_VARIABLE CLANG_VERSION_OUTPUT)
    string(REGEX REPLACE ".*clang version ([0-9]+\\.[0-9]+).*" "\\1" DESIGNAR_CLANG_VERSION "${CLANG_VERSION_OUTPUT}")

    execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "-v" OUTPUT_VARIABLE CLANG_COMPILER_VERSION ERROR_VARIABLE CLANG_COMPILER_VERSION)

    if("${CLANG_COMPILER_VERSION}" MATCHES "ucrt")
        set(DESIGNAR_RUNTIME_UCRT 1)
    endif()
elseif(CMAKE_COMPILER_IS_GNUCXX)
    set(DESIGNAR_COMPILER_GCC 1)

    execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "-dumpversion" OUTPUT_VARIABLE GCC_VERSION_OUTPUT)
    string(REGEX REPLACE "([0-9]+\\.[0-9]+).*" "\\1" DESIGNAR_GCC_VERSION "${GCC_VERSION_OUTPUT}")

    execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "-v" OUTPUT_VARIABLE GCC_COMPILER_VERSION ERROR_VARIABLE GCC_COMPILER_VERSION)
    string(REGEX MATCHALL ".*(tdm[64]*-[1-9]).*" DESIGNAR_COMPILER_GCC_TDM "${GCC_COMPILER_VERSION}")

    if("${GCC_COMPILER_VERSION}" MATCHES "ucrt")
        set(DESIGNAR_RUNTIME_UCRT 1)
    endif()

    execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "-dumpmachine" OUTPUT_VARIABLE GCC_MACHINE)
    string(STRIP "${GCC_MACHINE}" GCC_MACHINE)

    if(GCC_MACHINE MATCHES ".*w64.*")
        set(DESIGNAR_COMPILER_GCC_W64 1)
    endif()
else()
    message(WARNING "Unrecognized compiler: ${CMAKE_CXX_COMPILER_ID}. Use at your own risk.")
endif()
