@echo off
REM AI-generated: Quick test script for the built executable
echo ========================================
echo Testing GoH Mod Manager v1.0
echo ========================================
echo.

if exist "dist\GoH_Mod_Manager_v1.0.exe" (
    echo Starting GoH_Mod_Manager_v1.0.exe...
    echo.
    start "" "dist\GoH_Mod_Manager_v1.0.exe"
    echo.
    echo Program started!
    echo Check if the application window appears.
    echo.
) else (
    echo ERROR: Executable not found!
    echo Expected location: dist\GoH_Mod_Manager_v1.0.exe
    echo.
    echo Please run build.bat first to create the executable.
    echo.
    pause
    exit /b 1
)
