cmake_minimum_required(VERSION 3.1)

project(cimgui)

set (CMAKE_CXX_STANDARD 11)

# sdl2-backend user-conf
set (SDL2_ENABLED       TRUE)
set (SDL2_PATH          "C:/SDL2SDK/SDL2-2.28.0")
set (IMGUI_SDL2_DEFS    "-DCIMGUI_USE_SDL2" "-DCIMGUI_USE_SDLRENDERER")
set (IMGUI_SDL2_BACKEND "")


if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_tables.cpp)
	set(TABLES_SOURCE "imgui/imgui_tables.cpp")
else()
	set(TABLES_SOURCE "")
endif()

if (SDL2_ENABLED)
    set (IMGUI_BACKEND_SOURCES
        imgui/backends/imgui_impl_sdl2.cpp
        imgui/backends/imgui_impl_sdlrenderer.cpp)

    find_package(SDL2 PATHS ${SDL2_PATH}) # search sdl2 from provided path

    if (SDL2_FOUND)
        message ("Configuring for SDL2")
    endif ()
endif ()

#general settings
file(GLOB IMGUI_SOURCES
    cimgui.cpp
    imgui/imgui.cpp
    imgui/imgui_draw.cpp
    imgui/imgui_demo.cpp
    imgui/imgui_widgets.cpp
	${TABLES_SOURCE}
    ${IMGUI_BACKEND_SOURCES}
)

set(IMGUI_STATIC "no" CACHE STRING "Build as a static library")
set(IMGUI_FREETYPE "no" CACHE STRING "Build with freetype library")
set(IMGUI_LIBRARIES )

if(IMGUI_FREETYPE)
	FIND_PACKAGE(freetype REQUIRED PATHS ${FREETYPE_PATH})
	list(APPEND IMGUI_LIBRARIES freetype)
	list(APPEND IMGUI_SOURCES imgui/misc/freetype/imgui_freetype.cpp)
	add_definitions("-DCIMGUI_FREETYPE=1")
endif(IMGUI_FREETYPE)

#add library and link
if (IMGUI_STATIC)
    add_library(cimgui STATIC ${IMGUI_SOURCES})
else (IMGUI_STATIC)
    add_library(cimgui SHARED ${IMGUI_SOURCES})
endif (IMGUI_STATIC)

target_compile_definitions(cimgui PUBLIC IMGUI_DISABLE_OBSOLETE_FUNCTIONS=1)
if (WIN32)
    target_compile_definitions(cimgui PUBLIC IMGUI_IMPL_API=extern\t\"C\"\t__declspec\(dllexport\))
    list(APPEND IMGUI_LIBRARIES imm32)
else (WIN32)
    target_compile_definitions(cimgui PUBLIC IMGUI_IMPL_API=extern\t\"C\"\t)
endif (WIN32)

target_include_directories(cimgui PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(cimgui PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/imgui)
set_target_properties(cimgui PROPERTIES PREFIX "")
target_link_libraries(cimgui PUBLIC ${IMGUI_LIBRARIES})


if (SDL2_FOUND)
    target_include_directories (cimgui PUBLIC ${SDL2_INCLUDE_DIRS})
    target_link_libraries(cimgui PUBLIC ${SDL2_LIBRARIES})

    target_compile_definitions (cimgui PUBLIC ${IMGUI_SDL2_DEFS})
endif ()

#install
install(TARGETS cimgui
    RUNTIME DESTINATION  .
    LIBRARY DESTINATION  .
    ARCHIVE DESTINATION  .
)

#test
set(CIMGUI_TEST "no" CACHE STRING "Enable compilation of a test unit based on imgui null")

if (CIMGUI_TEST)
  add_subdirectory(test)
endif ()
