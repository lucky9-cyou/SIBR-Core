# Copyright (C) 2020, Inria
# GRAPHDECO research group, https://team.inria.fr/graphdeco
# All rights reserved.
# 
# This software is free for non-commercial, research and evaluation use 
# under the terms of the LICENSE.md file.
# 
# For inquiries contact sibr@inria.fr and/or George.Drettakis@inria.fr


## Included once for all sub project.
## It contain the whole cmake instructions to find necessary common dependencies.
## 3rdParty (provided by sibr_addlibrary win3rdParty or from external packages) are then available in cmake sub projects.
##
## Do not include this file more than once but you can modify it to fit to your own project.
## So please, read it carefully because you can use on of these dependencies for your project or appen new one.
##
## As it is included after camke options, you can use conditional if(<CMAKE_PROJ_OPT>)/endif() to encapsulate your 3rdParty.
##

## win3rdParty function allowing to auto check/download/update binaries dependencies for current windows compiler
## Please open this file in order to get more documentation and usage examples.
include_once(Win3rdParty)
include_once(sibr_library)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})

if(CONAN_EXPORTED) # in conan local cache
    # standard conan installation, deps will be defined in conanfile.py
    # and not necessary to call conan again, conan is already running
    include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)

	conan_add_remote(NAME inria URL https://api.bintray.com/conan/inria/conan)
	conan_add_remote(NAME bincrafters URL https://api.bintray.com/conan/bincrafters/public-conan)
	conan_add_remote(NAME conan URL https://api.bintray.com/conan/conan-community/conan)
	conan_add_remote(NAME conan-center URL https://conan.bintray.com)
	
    conan_basic_setup()
else() # in user space
	# Download automatically, you can also just copy the conan.cmake file
	if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
	message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
	file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake"
					"${CMAKE_BINARY_DIR}/conan.cmake" 
					TLS_VERIFY ON)
	endif()

    include(${CMAKE_BINARY_DIR}/conan.cmake)

	conan_add_remote(NAME inria URL https://api.bintray.com/conan/inria/conan)
	conan_add_remote(NAME bincrafters URL https://api.bintray.com/conan/bincrafters/public-conan)
	conan_add_remote(NAME conan URL https://api.bintray.com/conan/conan-community/conan)
	conan_add_remote(NAME conan-center URL https://conan.bintray.com)

    # Make sure to use conanfile.py to define dependencies, to stay consistent
    conan_cmake_run(CONANFILE ../conanfile.py
					BASIC_SETUP CMAKE_TARGETS
					BUILD missing
					CONFIGURATION_TYPES "Release;Debug")
					
    conan_basic_setup()
endif()

foreach(TGT ${CONAN_TARGETS})
set_target_properties(${TGT}
            PROPERTIES
                    MAP_IMPORTED_CONFIG_MINSIZEREL Release
                    MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
    )
endforeach()

Win3rdPartyGlobalCacheAction()

find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
find_package(glfw REQUIRED)

find_package(assimp REQUIRED)

find_package(ffmpeg REQUIRED)

find_package(embree3 REQUIRED)

find_package(eigen3 REQUIRED)
add_definitions(-DEIGEN_INITIALIZE_MATRICES_BY_ZERO)

set(Boost_REQUIRED_COMPONENTS "system;chrono;filesystem;date_time" CACHE INTERNAL "Boost Required Components")
find_package(Boost 1.71.0 REQUIRED COMPONENTS ${Boost_REQUIRED_COMPONENTS})

if(WIN32)
    add_definitions(/EHsc)
endif()

if(Boost_LIB_DIAGNOSTIC_DEFINITIONS)
    add_definitions(${Boost_LIB_DIAGNOSTIC_DEFINITIONS})
endif()

add_definitions(-DBOOST_ALL_DYN_LINK -DBOOST_ALL_NO_LIB)

find_package(OpenMP)

sibr_addlibrary(
    NAME NativeFileDialog
    MSVC14 "https://repo-sam.inria.fr/fungraph/dependencies/sibr/~0.9/nfd.7z"  
)

find_package(OpenCV REQUIRED) ## Use directly the OpenCVConfig.cmake provided

add_definitions(-DOPENCV_TRAITS_ENABLE_DEPRECATED)


sibr_gitlibrary(TARGET imgui
    GIT_REPOSITORY 	"https://gitlab.inria.fr/sibr/libs/imgui.git"
    GIT_TAG			"e7f0fa31b9fa3ee4ecd2620b9951f131b4e377c6"
)

sibr_gitlibrary(TARGET mrf
    GIT_REPOSITORY 	"https://gitlab.inria.fr/sibr/libs/mrf.git"
    GIT_TAG			"564e5e0b395c788d2f8b2cf4f879fed2493faea7"
)

sibr_gitlibrary(TARGET nanoflann
    GIT_REPOSITORY 	"https://gitlab.inria.fr/sibr/libs/nanoflann.git"
    GIT_TAG			"7a20a9ac0a1d34850fc3a9e398fc4a7618e8a69a"
)

sibr_gitlibrary(TARGET picojson
    GIT_REPOSITORY 	"https://gitlab.inria.fr/sibr/libs/picojson.git"
    GIT_TAG			"7cf8feee93c8383dddbcb6b64cf40b04e007c49f"
)

sibr_gitlibrary(TARGET rapidxml
    GIT_REPOSITORY 	"https://gitlab.inria.fr/sibr/libs/rapidxml.git"
    GIT_TAG			"069e87f5ec5ce1745253bd64d89644d6b894e516"
)

sibr_gitlibrary(TARGET xatlas
    GIT_REPOSITORY 	"https://gitlab.inria.fr/sibr/libs/xatlas.git"
    GIT_TAG			"0fbe06a5368da13fcdc3ee48d4bdb2919ed2a249"
    INCLUDE_DIRS 	"source/xatlas"
)

Win3rdPartyGlobalCacheAction()
