# include the DeSiGNAR specific macros
include(${PROJECT_SOURCE_DIR}/cmake/Macros.cmake)

# set the output directory for DeSiGNAR
set(LIBRARY_OUTPUT_PATH "${PROJECT_BINARY_DIR}/lib")

set(INCROOT "${PROJECT_SOURCE_DIR}/include/Designar")
set(SRCROOT ${PROJECT_SOURCE_DIR}/src)

# all source files
set(SRC
    ${SRCROOT}/array.cpp
    ${INCROOT}/array.hpp
    ${SRCROOT}/bitset.cpp
    ${INCROOT}/bitset.hpp
    ${SRCROOT}/buildgraph.cpp
    ${INCROOT}/buildgraph.hpp
    ${SRCROOT}/containeralgorithms.cpp
    ${INCROOT}/containeralgorithms.hpp
    ${SRCROOT}/geometricalgorithms.cpp
    ${INCROOT}/geometricalgorithms.hpp
    ${SRCROOT}/graphalgorithms.cpp
    ${INCROOT}/graphalgorithms.hpp
    ${SRCROOT}/graph.cpp
    ${INCROOT}/graph.hpp
    ${SRCROOT}/graphutilities.cpp
    ${INCROOT}/graphutilities.hpp
    ${SRCROOT}/hash.cpp
    ${INCROOT}/hash.hpp
    ${SRCROOT}/heap.cpp
    ${INCROOT}/heap.hpp
    ${SRCROOT}/intutilities.cpp
    ${INCROOT}/intutilities.hpp
    ${SRCROOT}/italgorithms.cpp
    ${INCROOT}/italgorithms.hpp
    ${SRCROOT}/iterator.cpp
    ${INCROOT}/iterator.hpp
    ${SRCROOT}/list.cpp
    ${INCROOT}/list.hpp
    ${SRCROOT}/map.cpp
    ${INCROOT}/map.hpp
    ${SRCROOT}/math.cpp
    ${INCROOT}/math.hpp
    ${SRCROOT}/nodesdef.cpp
    ${INCROOT}/nodesdef.hpp
    ${SRCROOT}/now.cpp
    ${INCROOT}/now.hpp
    ${SRCROOT}/point2D.cpp
    ${INCROOT}/point2D.hpp
    ${SRCROOT}/polygon.cpp
    ${INCROOT}/polygon.hpp
    ${SRCROOT}/queue.cpp
    ${INCROOT}/queue.hpp
    ${SRCROOT}/random.cpp
    ${INCROOT}/random.hpp
    ${SRCROOT}/range.cpp
    ${INCROOT}/range.hpp
    ${SRCROOT}/relation.cpp
    ${INCROOT}/relation.hpp
    ${SRCROOT}/segment.cpp
    ${INCROOT}/segment.hpp
    ${SRCROOT}/setalgorithms.cpp
    ${INCROOT}/setalgorithms.hpp
    ${SRCROOT}/set.cpp
    ${INCROOT}/set.hpp
    ${INCROOT}/singleton.hpp
    ${SRCROOT}/sort.cpp
    ${INCROOT}/sort.hpp
    ${SRCROOT}/stack.cpp
    ${INCROOT}/stack.hpp
    ${SRCROOT}/stringutilities.cpp
    ${INCROOT}/stringutilities.hpp
    ${SRCROOT}/tree.cpp
    ${INCROOT}/tree.hpp
    ${SRCROOT}/triangle.cpp
    ${INCROOT}/triangle.hpp
    ${SRCROOT}/types.cpp
    ${INCROOT}/types.hpp
    ${SRCROOT}/typetraits.cpp
    ${INCROOT}/typetraits.hpp
    ${SRCROOT}/vector2D.cpp
    ${INCROOT}/vector2D.hpp
)
source_group("" FILES ${SRC})

# define the Designar target
designar_add_library(Designar
                     SOURCES ${SRC})
