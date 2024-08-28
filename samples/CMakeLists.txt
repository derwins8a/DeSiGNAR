set(SRCROOT ${PROJECT_SOURCE_DIR}/samples/src)

# find dependencies
find_package(Threads REQUIRED)

# define the examples targets
designar_add_example(demo-buildgraph
                     SOURCES ${SRCROOT}/demo-buildgraph.cpp
                     DEPENDS Designar)

# external dependencies
target_link_libraries(demo-buildgraph PUBLIC Designar Threads::Threads)

# and so on...
designar_add_example(demo-concurrentqueue
                     SOURCES ${SRCROOT}/demo-concurrentqueue.cpp
                     DEPENDS Designar)

target_link_libraries(demo-concurrentqueue PUBLIC Designar Threads::Threads)

designar_add_example(demo-graph-components
                     SOURCES ${SRCROOT}/demo-graph-components.cpp
                     DEPENDS Designar)

target_link_libraries(demo-graph-components PUBLIC Designar Threads::Threads)

designar_add_example(demo-graph
                     SOURCES ${SRCROOT}/demo-graph.cpp
                     DEPENDS Designar)

target_link_libraries(demo-graph PUBLIC Designar Threads::Threads)

designar_add_example(demo-graph-mincut
                     SOURCES ${SRCROOT}/demo-graph-mincut.cpp
                     DEPENDS Designar)

target_link_libraries(demo-graph-mincut PUBLIC Designar Threads::Threads)

designar_add_example(demo-iterators
                     SOURCES ${SRCROOT}/demo-iterators.cpp
                     DEPENDS Designar)

target_link_libraries(demo-iterators PUBLIC Designar Threads::Threads)

designar_add_example(demo-topological_sort
                     SOURCES ${SRCROOT}/demo-topological_sort.cpp
                     DEPENDS Designar)

target_link_libraries(demo-topological_sort PUBLIC Designar Threads::Threads)
