include(CMakeParseArguments)

# include the compiler warnings helpers
include(${CMAKE_CURRENT_LIST_DIR}/CompilerWarnings.cmake)

# set the appropriate standard library on each platform for the given target
# example: set_stdlib(Designar)
function(set_stdlib target)
    # for gcc >= 4.0 on Windows, apply the DESIGNAR_USE_STATIC_STD_LIBS option if it is enabled
    if(DESIGNAR_OS_WINDOWS AND DESIGNAR_COMPILER_GCC AND NOT DESIGNAR_GCC_VERSION VERSION_LESS "4")
        if(DESIGNAR_USE_STATIC_STD_LIBS AND NOT DESIGNAR_COMPILER_GCC_TDM)
            target_link_libraries(${target} PRIVATE "-static-libgcc" "-static-libstdc++")
        elseif(NOT DESIGNAR_USE_STATIC_STD_LIBS AND DESIGNAR_COMPILER_GCC_TDM)
            target_link_libraries(${target} PRIVATE "-shared-libgcc" "-shared-libstdc++")
        endif()
    endif()
endfunction()

# add a new target
macro(designar_add_library target)

    # parse the arguments
    cmake_parse_arguments(THIS "STATIC" "" "SOURCES" ${ARGN})
    if (NOT "${THIS_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Extra unparsed arguments when calling add_library: ${THIS_UNPARSED_ARGUMENTS}")
    endif()

    # create the target
    if (THIS_STATIC)
        add_library(${target} STATIC ${THIS_SOURCES})
    else()
        add_library(${target} ${THIS_SOURCES})
    endif()

    set_file_warnings(${THIS_SOURCES})

    # define the export symbol of the module
    string(REPLACE "-" "_" NAME_UPPER "${target}")
    string(TOUPPER "${NAME_UPPER}" NAME_UPPER)
    set_target_properties(${target} PROPERTIES DEFINE_SYMBOL ${NAME_UPPER}_EXPORTS)

    # adjust the output file prefix/suffix to match our conventions
    if(BUILD_SHARED_LIBS AND NOT THIS_STATIC)
        set_target_properties(${target} PROPERTIES DEBUG_POSTFIX -d)
    else()
        set_target_properties(${target} PROPERTIES DEBUG_POSTFIX -s-d)
        set_target_properties(${target} PROPERTIES RELEASE_POSTFIX -s)
        set_target_properties(${target} PROPERTIES MINSIZEREL_POSTFIX -s)
        set_target_properties(${target} PROPERTIES RELWITHDEBINFO_POSTFIX -s)
    endif()

    # set the version and soversion of the target (for compatible systems -- mostly Linuxes)
    set_target_properties(${target} PROPERTIES SOVERSION ${VERSION_MAJOR}.${VERSION_MINOR})
    set_target_properties(${target} PROPERTIES VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

    # set the target's folder (for IDEs that support it, e.g. Visual Studio)
    set_target_properties(${target} PROPERTIES FOLDER "Designar")

    # set the target flags to use the appropriate C++ standard library
    set_stdlib(${target})

    # if using gcc >= 4.0 or clang >= 3.0 on a non-Windows platform, we must hide public symbols by default
    # (exported ones are explicitly marked)
    if(NOT DESIGNAR_OS_WINDOWS AND ((DESIGNAR_COMPILER_GCC AND NOT DESIGNAR_GCC_VERSION VERSION_LESS "4") OR (DESIGNAR_COMPILER_CLANG AND NOT DESIGNAR_CLANG_VERSION VERSION_LESS "3")))
        set_target_properties(${target} PROPERTIES COMPILE_FLAGS -fvisibility=hidden)
    endif()

    # add the install rule
    install(TARGETS ${target} EXPORT DESIGNARConfigExport
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT bin
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT bin
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT devel)

    # add <project>/include as public include directory
    target_include_directories(${target}
                               PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                               PRIVATE ${PROJECT_SOURCE_DIR}/src)

    # define DESIGNAR_STATIC if the build type is not set to 'shared'
    if(NOT BUILD_SHARED_LIBS)
        target_compile_definitions(${target} PUBLIC "DESIGNAR_STATIC")
    endif()

endmacro()

# add a new target which is a DeSiGNAR example
# example: designar_add_example(demo-graph
#                               SOURCES demo-graph ...
#                               DEPENDS Designar
macro(designar_add_example target)

    # parse the arguments
    cmake_parse_arguments(THIS "" "" "SOURCES;DEPENDS" ${ARGN})

    # set a source group for the source files
    source_group("" FILES ${THIS_SOURCES})

    # check whether resources must be added in target
    set(target_input ${THIS_SOURCES})

    add_executable(${target} ${target_input})

    set_file_warnings(${target_input})

    # set the debug suffix
    set_target_properties(${target} PROPERTIES DEBUG_POSTFIX -d)

    # set the target's folder (for IDEs that support it)
    set_target_properties(${target} PROPERTIES FOLDER "Samples")

    # set the target flags to use the appropriate C++ standard library
    set_stdlib(${target})

    # link the target to its DeSiGNAR dependency
    if(THIS_DEPENDS)
        target_link_libraries(${target} PRIVATE ${THIS_DEPENDS})
    endif()

endmacro()

# add a new target which is a DeSiGNAR test
# example: designar_add_test(test-array
#                            test-array.cpp ...
#                            Designar)
function(designar_add_test target SOURCES DEPENDS)

    # set a source group for the source files
    source_group("" FILES ${SOURCES})

    # create the target
    add_executable(${target} ${SOURCES})

    # set the target's folder (for IDEs that support it)
    set_target_properties(${target} PROPERTIES FOLDER "Tests")

    # link the target to its DeSiGNAR dependency
    if(DEPENDS)
        target_link_libraries(${target} PRIVATE ${DEPENDS})
    endif()
    
    # add the test
    add_test(${target} ${target})

endfunction()

# generate a DesignarConfig.cmake file (and associated files) from the targets registered against
# the EXPORT name "DesignarConfigExport" (EXPORT parameter of install(TARGETS))
function(designar_export_targets)
    # CMAKE_CURRENT_LIST_DIR or CMAKE_CURRENT_SOURCE_DIR not usable for files that are to be included like this one
    set(CURRENT_DIR "${PROJECT_SOURCE_DIR}/cmake")

    include(CMakePackageConfigHelpers)
    write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/DesignarConfigVersion.cmake"
                                     VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}
                                     COMPATIBILITY SameMajorVersion)

    if (BUILD_SHARED_LIBS)
        set(config_name "Shared")
    else()
        set(config_name "Static")
    endif()
    set(targets_config_filename "Designar${config_name}Targets.cmake")

    export(EXPORT DESIGNARConfigExport
           FILE "${CMAKE_CURRENT_BINARY_DIR}/${targets_config_filename}")

    set(config_package_location ${CMAKE_INSTALL_LIBDIR}/cmake/Designar)

    configure_package_config_file("${CURRENT_DIR}/DesignarConfig.cmake.in" "${CMAKE_CURRENT_BINARY_DIR}/DesignarConfig.cmake"
        INSTALL_DESTINATION "${config_package_location}")

    install(EXPORT DESIGNARConfigExport
            FILE ${targets_config_filename}
            DESTINATION ${config_package_location})

    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/DesignarConfig.cmake"
                  "${CMAKE_CURRENT_BINARY_DIR}/DesignarConfigVersion.cmake"
            DESTINATION ${config_package_location}
            COMPONENT devel)
endfunction()
