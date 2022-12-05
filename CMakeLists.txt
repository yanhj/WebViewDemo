cmake_minimum_required(VERSION 3.16.0)


set(APP_NAME "WebViewDemo")
project(${APP_NAME})

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 11)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(TOOL_DIR ${CMAKE_CURRENT_LIST_DIR})

list(APPEND QtModels Core Widgets Gui)
include(${TOOL_DIR}/qt-config.cmake)

file(GLOB TOOLS_SOURCE_FILES ${CMAKE_CURRENT_LIST_DIR}
        *.cpp
        *.h
        *.mm
        *.ui
        )

set(COMPILE_SOURCE ${TOOLS_SOURCE_FILES})

set(SOURCE_FILES ${COMPILE_SOURCE})

#依赖的mac库
add_compile_options(-x objective-c++)
set(CMAKE_EXE_LINKER_FLAGS "-w -framework Foundation -framework AVFoundation -framework AppKit -framework WebKit")

add_executable(${APP_NAME} ${SOURCE_FILES} )

include(${TOOL_DIR}/qt-link.cmake)

INSTALL( FILES ${CMAKE_CURRENT_LIST_DIR}/index.html DESTINATION ${PROJECT_BINARY_DIR}/)

