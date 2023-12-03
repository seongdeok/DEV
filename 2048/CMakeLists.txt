cmake_minimum_required(VERSION 3.27.9)
project(2048Game VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()
set(CMAKE_CXX_STANDARD 11)
add_executable(2048Game 
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Board.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/ConsoleDevice.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Unit.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/MatrixHelper.cpp
)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
