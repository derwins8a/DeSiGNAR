# from here:
#
# https://github.com/lefticus/cppbestpractices/blob/master/02-Use_the_Tools_Available.md

# helper function to enable compiler warnings for a specific set of files
function(set_file_warnings)
    option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" FALSE)

    set(CLANG_AND_GCC_WARNINGS
        -Wall
        -Wextra # reasonable and standard
        -Wno-shadow # don't warn the user if a variable declaration shadows one from a parent context
        -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps catch hard to track down memory errors
        -Wcast-align # warn for potential performance problem casts
        -Wunused # warn on anything being unused
        -Woverloaded-virtual # warn if you overload (not override) a virtual function
        -Wno-conversion # don't warn on type conversions that may lose data
        -Wno-sign-conversion # don't warn on sign conversions
        -Wno-double-promotion # don't warn if float is implicit promoted to double
        -Wformat=2 # warn on security issues around functions that format output (ie printf)
        # -Wimplicit-fallthrough # warn when a missing break causes control flow to continue at the next case in a switch statement (disabled until better compiler support for explicit fallthrough is available)
        -Wno-class-memaccess
        -Wno-sign-compare
    )
        
    if(WARNINGS_AS_ERRORS)
        set(CLANG_AND_GCC_WARNINGS ${CLANG_AND_GCC_WARNINGS} -Werror)
    endif()

    set(CLANG_WARNINGS
        ${CLANG_AND_GCC_WARNINGS}
        -Wno-unknown-warning-option # do not warn on GCC-specific warning diagnostic pragmas
        -Wfloat-equal
        -pedantic
        -Wno-write-strings
        -Wno-parentheses
    )

    set(GCC_WARNINGS
        ${CLANG_AND_GCC_WARNINGS}
        -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
        # -Wuseless-cast # warn if you perform a cast to the same type (disabled because it is not portable as some typedefs might vary between platforms)
    )

    # Don't enable -Wduplicated-branches for GCC < 8.1 since it will lead to false positives
    # https://github.com/gcc-mirror/gcc/commit/6bebae75035889a4844eb4d32a695bebf412bcd7
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 8.1)
        set(GCC_WARNINGS
            ${GCC_WARNINGS}
            -Wduplicated-branches # warn if if / else branches have duplicated code
        )
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(FILE_WARNINGS ${CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(FILE_WARNINGS ${GCC_WARNINGS})
    else()
        message(AUTHOR_WARNING "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()

    foreach(WARNING ${FILE_WARNINGS})
        set_property(SOURCE ${ARGV} APPEND_STRING PROPERTY COMPILE_FLAGS " ${WARNING}")
    endforeach()
endfunction()
