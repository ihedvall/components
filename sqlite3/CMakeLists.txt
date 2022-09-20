# Copyright 2021 Ingemar Hedvall
# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.20)
project(sqlite3_lib
        VERSION 3.37
        DESCRIPTION "Library for SQLite 3"
        LANGUAGES C)
set(CMAKE_DEBUG_POSTFIX d)

add_library(sqlite3 STATIC
        sqlite3.h sqlite3.c
        sqlite3ext.h)

target_include_directories(sqlite3 PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        )

set(SQLITE3_PUBLIC_HEADERS
        sqlite3.h
        sqlite3ext.h
        )

set_target_properties(sqlite3 PROPERTIES PUBLIC_HEADER "${SQLITE3_PUBLIC_HEADERS}")
get_target_property(LITE3 sqlite3 PUBLIC_HEADER)
message( STATUS "SQLite3 Target Includes: " "${LITE3}")

install(TARGETS sqlite3
        LIBRARY DESTINATION sqlite3/lib
        ARCHIVE DESTINATION sqlite3/lib
        RUNTIME DESTINATION sqlite3/bin
        PUBLIC_HEADER DESTINATION sqlite3/include)