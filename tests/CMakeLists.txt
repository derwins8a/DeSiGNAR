set(SRCROOT "${PROJECT_SOURCE_DIR}/tests/src")

include_directories("${PROJECT_SOURCE_DIR}/include")

# import cmake options
include(CTest)

designar_add_test(test-array "${SRCROOT}/test-array.cpp" Designar)
designar_add_test(test-bitset "${SRCROOT}/test-bitset.cpp" Designar)
designar_add_test(test-dllist "${SRCROOT}/test-dllist.cpp" Designar)
designar_add_test(test-graph-cycles "${SRCROOT}/test-graph-cycles.cpp" Designar)
designar_add_test(test-hash "${SRCROOT}/test-hash.cpp" Designar)
designar_add_test(test-heap "${SRCROOT}/test-heap.cpp" Designar)
designar_add_test(test-in-out-graph "${SRCROOT}/test-in-out-graph.cpp" Designar)
designar_add_test(test-intutilities "${SRCROOT}/test-intutilities.cpp" Designar)
designar_add_test(test-map "${SRCROOT}/test-map.cpp" Designar)
designar_add_test(test-mtreenode "${SRCROOT}/test-mtreenode.cpp" Designar)
designar_add_test(test-pow "${SRCROOT}/test-pow.cpp" Designar)
designar_add_test(test-queue "${SRCROOT}/test-queue.cpp" Designar)
designar_add_test(test-random "${SRCROOT}/test-random.cpp" Designar)
designar_add_test(test-range "${SRCROOT}/test-range.cpp" Designar)
designar_add_test(test-relation "${SRCROOT}/test-relation.cpp" Designar)
designar_add_test(test-sllist "${SRCROOT}/test-sllist.cpp" Designar)
designar_add_test(test-stack "${SRCROOT}/test-stack.cpp" Designar)
designar_add_test(test-stringutilities "${SRCROOT}/test-stringutilities.cpp" Designar)
designar_add_test(test-tree "${SRCROOT}/test-tree.cpp" Designar)
designar_add_test(test-vector2D "${SRCROOT}/test-vector2D.cpp" Designar)

# automatically run the tests at the end of the build
add_custom_target(runtests ALL
                  DEPENDS test-array test-bitset test-dllist test-graph-cycles test-hash test-heap test-in-out-graph test-intutilities test-map test-mtreenode test-pow test-queue test-random test-range test-relation test-range test-sllist test-stack test-stringutilities test-tree test-vector2D
)

add_custom_command(TARGET runtests
                   COMMENT "Run tests"
                   POST_BUILD COMMAND ctest ARGS --output-on-failure
)
