@echo off
REM AI-generated: quick launcher for the built executable
echo ========================================
echo Testing GoH Mod Manager
echo ========================================
echo.

if exist "dist\goh_mod_manager.exe" (
    echo Starting goh_mod_manager.exe...
    echo.
    start "" "dist\goh_mod_manager.exe"
    echo.
    echo Program started!
    echo Check if the application window appears.
    echo.
) else (
    echo ERROR: Executable not found!
    echo Expected location: dist\goh_mod_manager.exe
    echo.
    echo Build it first:
    echo   uv run pyinstaller --onefile --clean --windowed --name goh_mod_manager goh_mod_manager\__main__.py
    echo.
    pause
    exit /b 1
)
