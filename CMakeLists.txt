cmake_minimum_required(VERSION 3.14)
project(mix)

# ----- options ----- #

option(MIX_BUILD_TESTS "build tests" ON)
option(MIX_INSTALL "install headers and libs" ON)
option(MIX_HOLD_DEPS "do not update existing deps" OFF)

# ----- dependencies ----- #

include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_UPDATES_DISCONNECTED ${MIX_HOLD_DEPS})

if(NOT MIX_DEPS_DIR)
    get_filename_component(MIX_DEPS_DIR ${CMAKE_CURRENT_BINARY_DIR}/deps ABSOLUTE)
    message(STATUS "`MIX_DEPS_DIR` is not set. set `MIX_DEPS_DIR` to `${MIX_DEPS_DIR}` by default.")
endif()

macro(mix_import_git_dep name repo commit)
    FetchContent_Declare(${name}
        GIT_REPOSITORY ${repo}
        GIT_TAG ${commit}
        GIT_SHALLOW TRUE
        SOURCE_DIR ${MIX_DEPS_DIR}/${name}
        BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${name}-build
        SUBBUILD_DIR ${MIX_DEPS_DIR}/${name}-subbuild)
    FetchContent_MakeAvailable(${name})
endmacro()

if(NOT TARGET logger_static)
    set(LOGGER_DEPS_DIR ${MIX_DEPS_DIR})
    set(LOGGER_BUILD_TESTS OFF)
    set(LOGGER_INSTALL ${MIX_INSTALL})
    set(LOGGER_HOLD_DEPS ${MIX_HOLD_DEPS})
    if(MIX_DEP_LOGGER_SOURCE_DIR)
        add_subdirectory(${MIX_DEP_LOGGER_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/logger-build)
        set(logger_SOURCE_DIR ${MIX_DEP_LOGGER_SOURCE_DIR})
    else()
        mix_import_git_dep(logger "https://github.com/ouonline/logger.git" master)
    endif()
endif()

if(NOT TARGET cutils_static)
    set(CUTILS_DEPS_DIR ${MIX_DEPS_DIR})
    set(CUTILS_BUILD_TESTS OFF)
    set(CUTILS_INSTALL ${MIX_INSTALL})
    set(CUTILS_HOLD_DEPS ${MIX_HOLD_DEPS})
    if(MIX_DEP_CUTILS_SOURCE_DIR)
        add_subdirectory(${MIX_DEP_CUTILS_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/cutils-build)
        set(cutils_SOURCE_DIR ${MIX_DEP_CUTILS_SOURCE_DIR})
    else()
        mix_import_git_dep(cutils "https://github.com/ouonline/cutils.git" master)
    endif()
endif()

# ----- targets ----- #

set(__ASAN_FLAGS__ "-fsanitize=undefined -fsanitize=address -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${__ASAN_FLAGS__}")
unset(__ASAN_FLAGS__)

execute_process(COMMAND bison -d ${CMAKE_CURRENT_SOURCE_DIR}/bison/mix.y -Wcounterexamples)

file(GLOB __MIX_SRC__ ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c ${CMAKE_CURRENT_BINARY_DIR}/mix.tab.c)
add_library(mix_static STATIC ${__MIX_SRC__})
unset(__MIX_SRC__)

target_include_directories(mix_static PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(mix_static PUBLIC cutils_static logger_static m)

# ----- tools ----- #

add_subdirectory(tools)
