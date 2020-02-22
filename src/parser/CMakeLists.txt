cmake_minimum_required(VERSION 3.0.2)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
# markdown parser
set(BISON_SRC "md-parser.y")
BISON_TARGET(md_parser ${BISON_SRC} ${CMAKE_CURRENT_BINARY_DIR}/md-parser.cpp)
set(FLEX_SRC "md-scanner.l")
FLEX_TARGET(md_scanner ${FLEX_SRC} ${CMAKE_CURRENT_BINARY_DIR}/md-scanner.cpp)
ADD_FLEX_BISON_DEPENDENCY(md_scanner md_parser)

add_executable(shadoc_markdown ${BISON_md_parser_OUTPUTS} ${FLEX_md_scanner_OUTPUTS})
target_link_libraries(shadoc_markdown ${FLEX_LIBRARIES})
message(STATUS "flex lib:" ${FLEX_LIBRARIES})

