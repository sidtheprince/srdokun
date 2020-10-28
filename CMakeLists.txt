cmake_minimum_required(VERSION 3.0) # you can change the version if you need to.
###########
# make sure srlua version matches the lua version used by dokun 
project(srdokun)
###########
set(VERSION_MAJOR "1")
set(VERSION_MINOR "0")
set(VERSION_PATCH "2")
set(PROJECT_VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})
###########
if(WIN32)
    set(WINDOWS TRUE)
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(LINUX TRUE)
    option(SRDOKUN_CLANG "use clang" OFF) # clang
    option(SRDOKUN_GCC   "use gcc"   ON ) # gcc   - shipped with Ubuntu by default    
    set(CMAKE_C_COMPILER   /usr/bin/gcc)
    set(CMAKE_CXX_COMPILER /usr/bin/g++)
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(MACOSX TRUE)
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Android")
    set(ANDROID TRUE)
endif()
###########
if(LINUX) # if user chooses to compile with clang
if(SRDOKUN_CLANG) # cmake -DSRDOKUN_CLANG=ON -G"Unix Makefiles"
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang") # check if clang is set as the current compiler
    set(SRDOKUN_GCC OFF )  
    set(SRDOKUN_CLANG ON) # use clang (if not using gcc)
    set(CMAKE_C_COMPILER   /usr/bin/clang  )
    set(CMAKE_CXX_COMPILER /usr/bin/clang++)
else()
    message(WARNING "clang is not set as the default compiler!")
endif()
endif()
endif()
###########
set(glue_src  srglue.c   )
set(srlua_src srlua.cpp) #${lua_src}) # remove comment to build srlua with normal Lua
###########
if(WIN32)
set(opengl_src    opengl32.lib glu32.lib)
set(vulkan_src    vulkan-1.lib          )
set(openal_src    OpenAL32.lib          )
set(winsocket_src ws2_32.lib            )
set(dokun_src     libdokun.a            )
endif()
if(LINUX)
set(dokun_src  libdokun.a                           )
set(opengl_src libGL.so libGLU.so                   )
set(OpenGL_GL_PREFERENCE "LEGACY"                   ) # LEGACY(libGL.so) OR GLVND(libOpenGL.so and libGLX.so)
set(vulkan_src libvulkan.so                         )
set(openal_src libopenal.so                         )
set(posix_src  libpthread.so libdl.so libm.so       )
set(x11_src    libX11.a libxcb.a libXau.a libXdmcp.a) 
endif()
# use C++ 11
if(SRDOKUN_GCC)#if(CMAKE_COMPILER_IS_GNUCXX) # gcc
    set(CMAKE_CXX_FLAGS "-std=gnu++11 -no-pie -L/lib/OpenAL32.lib")
endif()
if(SRDOKUN_CLANG) # clang
    set(CMAKE_CXX_FLAGS "-std=c++11 -w -L/lib/OpenAL32.lib"       )
endif()
########### look for "includes" (.h, .hpp) in these folders
include_directories(${CMAKE_CURRENT_SOURCE_DIR}           )
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/54)
##
########### look for "libraries (source: .c, .cpp, .a)" in these folders
link_directories(${CMAKE_CURRENT_SOURCE_DIR}    )
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/lib)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
if(WIN32)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/win32)
endif()
if(LINUX)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/linux)
endif()
# build executables
add_executable(glue   ${glue_src}) # no dependencies
add_executable(srlua ${srlua_src}) # depends on lua source which dokun can provide once linked to "libdokun.a"
###########
# link against dokun (contains lua source)
target_link_libraries(srlua ${dokun_src})
if(WIN32)
    target_link_libraries(srlua ${winsocket_src})
	target_link_libraries(srlua ${openal_src}   )	
	find_package(OPENGL)
	if(OPENGL_FOUND)
	    target_link_libraries(srlua ${opengl_src})
	endif()
	# find_package(Vulkan) # optional
	#if(Vulkan_FOUND)
	#    target_link_libraries(srlua ${vulkan_src})
	# endif()
endif()
if(LINUX)
    target_link_libraries(srlua ${posix_src}  )	
    find_package(X11 REQUIRED)
    if(X11_FOUND)
	    target_link_libraries(srlua ${x11_src})
    endif()
	find_package(OpenGL REQUIRED)
    if(OPENGL_FOUND)
	    target_link_libraries(srlua ${opengl_src})
	endif()	
	#find_package(Vulkan) # optional
	#if(Vulkan_FOUND)
	#    target_link_libraries(srlua ${vulkan_src})
	#endif()
	find_package(OpenAL REQUIRED)
	if(OPENAL_FOUND)
		target_link_libraries(srlua ${openal_src})
	endif()	
endif()

# Win32
# cd srdokun
# cmake -G"MinGW Makefiles"
# mingw32-make
# glue.exe srlua.exe test.lua test.exe

# GNU/Linux
# cmake -G"Unix Makefiles"
# make
# ./glue ./srlua test.lua test

# http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/
