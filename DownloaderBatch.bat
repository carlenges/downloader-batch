@echo off
chcp 65001 >nul
title yt-dlp Batch Downloader

:: === Define tools folder ===
set "tools_dir=%~dp0tools"

:: === Check if yt-dlp is installed ===
where yt-dlp.exe >nul 2>&1
if errorlevel 1 (
    echo yt-dlp not found, downloading...

    if not exist "%tools_dir%" mkdir "%tools_dir%"

    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -o "%tools_dir%\yt-dlp.exe"
    if errorlevel 1 (
        echo [ERROR] Failed to download yt-dlp.
        pause
        exit /b
    )
)

:: === Check if ffmpeg is installed ===
where ffmpeg.exe >nul 2>&1
if errorlevel 1 (
    echo ffmpeg not found, downloading...

    if not exist "%tools_dir%" mkdir "%tools_dir%"

    echo ffmpeg automatic download not implemented in this script. Please manually download from:
    echo https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
    echo and extract ffmpeg.exe to %tools_dir%
    pause
    exit /b
)

:: === Add tools folder to PATH temporarily for this script ===
set "PATH=%tools_dir%;%PATH%"

:: === User input ===
set /p "title=Video/Playlist Title: "
set /p "artist=Artist: "
set /p "url=URL: "
set /p "type=Type (playlist/url): "
set /p "format=Format (mp3/mp4): "

:: === Output folder ===
set "output_dir=%USERPROFILE%\Downloads\%artist% - %title%"
if not exist "%output_dir%" mkdir "%output_dir%"

:: === Common yt-dlp options ===
set "common_opts=--no-mtime --ignore-errors"

:: === Call yt-dlp with full path to avoid confusion ===
set "yt_dlp_cmd=%tools_dir%\yt-dlp.exe"

:: === Main download logic ===
if /i "%type%"=="url" (
    if /i "%format%"=="mp3" (
        "%yt_dlp_cmd%" %common_opts% -x --audio-format mp3 --audio-quality 0 ^
            --embed-thumbnail --embed-metadata --add-metadata ^
            -o "%output_dir%\%%(title)s - %artist%.%%(ext)s" "%url%"
    ) else if /i "%format%"=="mp4" (
        "%yt_dlp_cmd%" %common_opts% -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" ^
            --merge-output-format mp4 --embed-thumbnail --embed-metadata ^
            -o "%output_dir%\%%(title)s - %artist%.%%(ext)s" "%url%"
    ) else (
        echo [ERROR] Invalid format. Use only mp3 or mp4.
        pause
        exit /b
    )
) else if /i "%type%"=="playlist" (
    if /i "%format%"=="mp3" (
        "%yt_dlp_cmd%" %common_opts% -x --audio-format mp3 --audio-quality 0 ^
            --embed-thumbnail --embed-metadata --add-metadata ^
            -o "%output_dir%\%%(playlist_index)02d - %title% - %artist%.%%(ext)s" "%url%"
    ) else if /i "%format%"=="mp4" (
        "%yt_dlp_cmd%" %common_opts% -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" ^
            --merge-output-format mp4 --embed-thumbnail --embed-metadata ^
            -o "%output_dir%\%%(playlist_index)02d - %title% - %artist%.%%(ext)s" "%url%"
    ) else (
        echo [ERROR] Invalid format. Use only mp3 or mp4.
        pause
        exit /b
    )
) else (
    echo [ERROR] Invalid type. Use only "url" or "playlist".
    pause
    exit /b
)

echo.
echo [DONE] Download completed. Files saved in:
echo %output_dir%
pause
exit /b
