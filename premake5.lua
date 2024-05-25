-- premake5.lua

workspace "FastNoise2"
    architecture "x86_64"
    startproject "FastNoise2"

    configurations
    {
        "Debug",
        "Release"
    }

project "FastNoise2"
    location "FastNoise2"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("bin/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
    objdir ("bin-int/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")

    files
    {
        "src/**.h",
        "src/**.cpp"
    }

    includedirs
    {
        "src"
    }

    filter "system:windows"
        systemversion "latest"
        
        defines
        {
            "FN2_PLATFORM_WINDOWS"
        }
        
    filter "system:linux"
        pic "On"
        systemversion "latest"
        
        defines
        {
            "FN2_PLATFORM_LINUX"
        }
        
    filter "system:macosx"
        systemversion "latest"
        
        defines
        {
            "FN2_PLATFORM_MAC"
        }

    filter "configurations:Debug"
        defines "FN2_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "FN2_RELEASE"
        runtime "Release"
        optimize "on"

-- Set up architecture-specific defines
filter "architecture:arm"
    defines
    {
        "FASTSIMD_COMPILE_ARM"
    }

filter "architecture:armv7"
    defines
    {
        "FASTSIMD_COMPILE_ARMV7",
        "FASTSIMD_COMPILE_HAVE_NEON"
    }

filter "architecture:arm64"
    defines
    {
        "FASTSIMD_COMPILE_HAVE_NEON"
    }

filter "architecture:aarch64"
    defines
    {
        "FASTSIMD_COMPILE_AARCH64",
        "FASTSIMD_COMPILE_HAVE_NEON"
    }

-- Set up build options
newoption
{
    trigger = "with-noisetool",
    description = "Build the NoiseTool application"
}

newoption
{
    trigger = "with-tests",
    description = "Build the test applications"
}

if _OPTIONS["with-noisetool"] then
    include "NoiseTool"
end

if _OPTIONS["with-tests"] then
    include "tests"
end

-- Include the subdirectories for NoiseTool and tests if the options are enabled
if _OPTIONS["with-noisetool"] then
    project "NoiseTool"
        location "NoiseTool"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++17"
        staticruntime "on"
        
        targetdir ("bin/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
        objdir ("bin-int/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
        
        files
        {
            "NoiseTool/**.h",
            "NoiseTool/**.cpp"
        }
        
        includedirs
        {
            "NoiseTool",
            "src"
        }
        
        links
        {
            "FastNoise2"
        }
        
        filter "system:windows"
            systemversion "latest"
            
            defines
            {
                "FN2_PLATFORM_WINDOWS"
            }
            
        filter "system:linux"
            pic "On"
            systemversion "latest"
            
            defines
            {
                "FN2_PLATFORM_LINUX"
            }
            
        filter "system:macosx"
            systemversion "latest"
            
            defines
            {
                "FN2_PLATFORM_MAC"
            }
        
        filter "configurations:Debug"
            defines "FN2_DEBUG"
            runtime "Debug"
            symbols "on"
        
        filter "configurations:Release"
            defines "FN2_RELEASE"
            runtime "Release"
            optimize "on"
end

if _OPTIONS["with-tests"] then
    project "Tests"
        location "tests"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++17"
        staticruntime "on"
        
        targetdir ("bin/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
        objdir ("bin-int/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
        
        files
        {
            "tests/**.h",
            "tests/**.cpp"
        }
        
        includedirs
        {
            "tests",
            "src"
        }
        
        links
        {
            "FastNoise2"
        }
        
        filter "system:windows"
            systemversion "latest"
            
            defines
            {
                "FN2_PLATFORM_WINDOWS"
            }
            
        filter "system:linux"
            pic "On"
            systemversion "latest"
            
            defines
            {
                "FN2_PLATFORM_LINUX"
            }
            
        filter "system:macosx"
            systemversion "latest"
            
            defines
            {
                "FN2_PLATFORM_MAC"
            }
        
        filter "configurations:Debug"
            defines "FN2_DEBUG"
            runtime "Debug"
            symbols "on"
        
        filter "configurations:Release"
            defines "FN2_RELEASE"
            runtime "Release"
            optimize "on"
end
