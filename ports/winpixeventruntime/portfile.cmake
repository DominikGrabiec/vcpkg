vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/PixEvents
    REF 3a7e70dde7bf54f02f9d2e9dd6d3350c6cfb962f
    SHA512 91b7a2f8c83d8e848ec89866e8f30092a1e49f5d327fd5dd972bdb6f8848cef28fd135f6304df0811241a95f379089853edf98c451dc680fc6d7838a8be8edd1
    HEAD_REF main
)

set(BUILDTREE_PATH "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}")
if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW AND VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    if(VCPKG_TARGET_ARCHITECTURE MATCHES "x86")
        set(PLATFORM_ARG PLATFORM x86) # it's x86, not Win32 in sln file
    endif()

    vcpkg_msbuild_install(
        SOURCE_PATH "${SOURCE_PATH}"
        PROJECT_SUBPATH PixEvents.sln
        ${PLATFORM_ARG}
        NO_INSTALL
    )

    file(GLOB includes "${SOURCE_PATH}/include/*.h")
    file(COPY ${includes} DESTINATION "${CURRENT_PACKAGES_DIR}/include")

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        set(release_output_dir "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/output/Release/${VCPKG_TARGET_ARCHITECTURE}/WinPixEventRuntime")

        if(VCPKG_TARGET_IS_UWP)
            file(GLOB dlls "${release_output_dir}_UWP/*.dll")
            file(GLOB libs "${release_output_dir}_UWP/*.lib")
        else()
            file(GLOB dlls "${release_output_dir}/*.dll")
            file(GLOB libs "${release_output_dir}/*.lib")
        endif()

        if(NOT dlls STREQUAL "")
            file(COPY ${dlls} DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
        endif()
        if(NOT libs STREQUAL "")
            file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
        endif()
    endif()

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        set(debug_output_dir "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/output/Debug/${VCPKG_TARGET_ARCHITECTURE}/WinPixEventRuntime")

        if(VCPKG_TARGET_IS_UWP)
            file(GLOB dlls "${debug_output_dir}_UWP/*.dll")
            file(GLOB libs "${debug_output_dir}_UWP/*.lib")
        else()
            file(GLOB dlls "${debug_output_dir}/*.dll")
            file(GLOB libs "${debug_output_dir}/*.lib")
        endif()

        if(NOT dlls STREQUAL "")
            file(COPY ${dlls} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
        endif()
        if(NOT libs STREQUAL "")
            file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
        endif()
    endif()

    vcpkg_copy_pdbs()
endif()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/WinPixEventRuntimeConfig.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
