# set cmake minimum version
cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

### require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

# define a macro that helps defining an option
macro(set_option var default type docstring)
    if(NOT DEFINED ${var})
        set(${var} ${default})
    endif()
    set(${var} ${${var}} CACHE ${type} ${docstring} FORCE)
endmacro()

# these options have to be set before CMake detects/configures the toolchain

# determine whether to create a debug or release build
set_option(CMAKE_BUILD_TYPE Release STRING "Choose the type of build (Debug or Release)")

# project name
project(Designar
        VERSION 2.0.1
        LANGUAGES CXX
)

# include the configuration file
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Config.cmake)

# we use the paths from the cmake GNUInstallDirs module as defaults
# you can override these if you like
# https://cmake.org/cmake/help/v3.0/module/GNUInstallDirs.html
include(GNUInstallDirs)

# setup version numbers
set(VERSION_MAJOR 2)
set(VERSION_MINOR 0)
set(VERSION_PATCH 1)

# add an option for building the examples
set_option(DESIGNAR_BUILD_EXAMPLES FALSE BOOL "TRUE to build the DeSiGNAR examples, FALSE to ignore them")

# add an option for building the test suite
set_option(DESIGNAR_BUILD_TEST_SUITE FALSE BOOL "TRUE to build the DeSiGNAR test suite, FALSE to ignore it")

# install directories
# For miscellaneous files
set(DEFAULT_INSTALL_MISC_DIR share/Designar)

# enable project folders
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMake")

# globally include folder
include_directories(${PROJECT_SOURCE_DIR}/include)

# add the subdirectories
add_subdirectory(src)
if(DESIGNAR_BUILD_EXAMPLES)
    add_subdirectory(samples)
endif()
if(DESIGNAR_BUILD_TEST_SUITE)
    # enable_testing()
    add_subdirectory(tests)
endif()

# install pkg-config files by default
set(DESIGNAR_INSTALL_PKGCONFIG_DEFAULT FALSE)

set_option(DESIGNAR_INSTALL_PKGCONFIG_FILES ${DESIGNAR_INSTALL_PKGCONFIG_DEFAULT} BOOL "TRUE to automatically install pkg-config files so other projects can find DeSiGNAR")

if(DESIGNAR_INSTALL_PKGCONFIG_FILES)
    # account for CMAKE_INSTALL_LIBDIR potentially being an absolute path
    file(RELATIVE_PATH DESIGNAR_RELATIVE_INSTALL_LIBDIR ${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_FULL_LIBDIR})

    # set pkgconfig install directory
    # this could be e.g. macports on mac or msys2 on windows etc.
    set(DESIGNAR_PKGCONFIG_DIR "/${DESIGNAR_RELATIVE_INSTALL_LIBDIR}/pkgconfig")

    set_option(DESIGNAR_PKGCONFIG_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/${DESIGNAR_PKGCONFIG_DIR}" PATH "Install directory for DeSiGNAR's pkg-config .pc file")

    CONFIGURE_FILE(
        "tools/pkg-config/designar.pc.in"
        "tools/pkg-config/designar.pc"
        @ONLY)
    INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/tools/pkg-config/designar.pc"
        DESTINATION "${DESIGNAR_PKGCONFIG_INSTALL_PREFIX}")
endif()

# setup the install rules
install(DIRECTORY include
        DESTINATION .
        COMPONENT devel
        FILES_MATCHING PATTERN "*.hpp" PATTERN "*.inl")

install(FILES LICENSE DESTINATION ${CMAKE_INSTALL_DOCDIR})
install(FILES README.md DESTINATION ${CMAKE_INSTALL_DOCDIR})

designar_export_targets()

set(CPACK_PACKAGE_NAME_SUMMARY "DeSiGNAR")
set(CPACK_PACKAGE_VENDOR "R3mmurd")
set(CPACK_PACKAGE_FILE_NAME "DeSiGNAR-${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}-${CMAKE_CXX_COMPILER_ID}-${CMAKE_CXX_COMPILER_VERSION}-${CMAKE_BUILD_TYPE}")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "DeSiGNAR ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")
set(CPACK_MONOLITHIC_INSTALL ON)

include(CPack)
