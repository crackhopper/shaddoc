cmake_minimum_required(VERSION 3.0.2)
add_definitions(-std=c++11)
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
# markdown parser

# bison
set(BISON_SRC "md-parser.y")
BISON_TARGET(
    md_parser 
    ${BISON_SRC} 
    ${CMAKE_CURRENT_BINARY_DIR}/md-parser.cpp
    VERBOSE ${CMAKE_CURRENT_BINARY_DIR}/bison.log
    COMPILE_FLAGS -Wconflicts-sr
)

# flex
set(FLEX_SRC "md-scanner.l")
FLEX_TARGET(
    md_scanner 
    ${FLEX_SRC} 
    ${CMAKE_CURRENT_BINARY_DIR}/md-scanner.cpp
    COMPILE_FLAGS
)
ADD_FLEX_BISON_DEPENDENCY(md_scanner md_parser)

set(SRC 
    "md-type.cpp"
    ${BISON_md_parser_OUTPUTS} 
    ${FLEX_md_scanner_OUTPUTS}
)
add_executable(shadoc_markdown ${SRC})
target_link_libraries(shadoc_markdown ${FLEX_LIBRARIES})
message(STATUS "flex lib:" ${FLEX_LIBRARIES})
set(SRC 
    "md-preprocesser.cpp"
 )
add_executable(shadoc_markdown_preprocess ${SRC})