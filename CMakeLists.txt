cmake_minimum_required(VERSION 3.7.2) # you can change the version if you need to.
###########
# make sure srlua version matches the lua version used by dokun 
project(srlua) 
###########
set(VERSION_MAJOR "1")
set(VERSION_MINOR "0")
set(VERSION_PATCH "1")
set(PROJECT_VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})
###########
if(WIN32)
    set(WINDOWS TRUE)
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(LINUX TRUE)
    set(CMAKE_C_COMPILER   /usr/bin/x86_64-linux-gnu-gcc)
    set(CMAKE_CXX_COMPILER /usr/bin/x86_64-linux-gnu-g++)
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(MACOSX TRUE)
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Android")
    set(ANDROID TRUE)
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
if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-std=gnu++11 -no-pie -L/lib/OpenAL32.lib")
endif()
########### look for "includes" (.h, .hpp) in these folders
include_directories(${CMAKE_CURRENT_SOURCE_DIR}           )
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/53)
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
add_executable(srlua ${srlua_src}) # depends on lua source which dokun can provide once linked to (libdokun.a)
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
	# find_package(Vulkan)
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
	if(Vulkan_FOUND)
	    target_link_libraries(srlua ${vulkan_src})
	endif()
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
