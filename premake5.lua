-- premake5.lua

workspace "FastNoise2"
    architecture "x86_64"
    startproject "FastNoise2"

    configurations
    {
        "Debug",
        "Release"
    }

project "FastNoise"
    location "include"
    kind "StaticLib" -- Change this to "SharedLib" if you are building a DLL
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("bin/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
    objdir ("bin-int/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")

    files
    {
        "./include/*.h",
        "./include/*.cpp",
        "./include/FastSIMD/**.h",
        "./include/FastSIMD/**.cpp",
        "./include/FastSIMD/**.inl",
        "./include/FastNoise/**.h",
        "./include/FastNoise/**.cpp",
        "./include/FastNoise/**.inl",
    }

    includedirs
    {
        "./include/",
    }

    filter "system:windows"
        systemversion "latest"
        
        defines
        {
            "WIN32",
            "_WINDOWS"
        }

    filter "configurations:Debug"
        defines { "FN2_DEBUG", "FASTNOISE2_EXPORTS" } -- Define FASTNOISE2_EXPORTS if building DLL
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines { "FN2_RELEASE", "FASTNOISE2_EXPORTS" } -- Define FASTNOISE2_EXPORTS if building DLL
        runtime "Release"
        optimize "on"

    -- Apply /arch:AVX flag to specific files
    filter { "files:src/FastSIMD/FastSIMD_Level_AVX2.cpp" }
        buildoptions { "/arch:AVX" }

    filter { "files:src/FastSIMD/FastSIMD_Level_AVX512.cpp" }
        buildoptions { "/arch:AVX512" }
