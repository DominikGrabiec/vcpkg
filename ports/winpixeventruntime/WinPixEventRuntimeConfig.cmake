if(NOT TARGET WinPixEventRuntime::WinPixEventRuntime)
	add_library(WinPixEventRuntime::WinPixEventRuntime UNKNOWN IMPORTED)

	find_path(WinPixEventRuntime_INCLUDE_DIR NAMES pix3.h)

	set_target_properties(WinPixEventRuntime::WinPixEventRuntime PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${WinPixEventRuntime_INCLUDE_DIR}"
	)

	find_library(WinPixEventRuntime_LIBRARY_RELEASE NAMES WinPixEventRuntime PATHS "${CMAKE_CURRENT_LIST_DIR}/../../lib" NO_DEFAULT_PATH REQUIRED)
	find_library(WinPixEventRuntime_LIBRARY_DEBUG NAMES WinPixEventRuntime PATHS "${CMAKE_CURRENT_LIST_DIR}/../../debug/lib" NO_DEFAULT_PATH REQUIRED)

	set_target_properties(WinPixEventRuntime::WinPixEventRuntime PROPERTIES
		IMPORTED_LOCATION_DEBUG "${WinPixEventRuntime_LIBRARY_DEBUG}"
		IMPORTED_LOCATION_RELEASE "${WinPixEventRuntime_LIBRARY_RELEASE}"
		IMPORTED_CONFIGURATIONS "Release;Debug"
	)
endif()
