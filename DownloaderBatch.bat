@echo off
chcp 65001 >nul
title yt-dlp Batch Downloader

:: === Check if yt-dlp is installed ===
where yt-dlp.exe >nul 2>&1
if errorlevel 1 (
    echo [ERROR] yt-dlp is not installed or not in PATH.
    pause
    exit /b
)

:: === Check if ffmpeg is installed ===
where ffmpeg.exe >nul 2>&1
if errorlevel 1 (
    echo [ERROR] ffmpeg is not installed or not in PATH.
    pause
    exit /b
)

:: === Get user input ===
set /p "title=Video/Playlist Title: "
set /p "artist=Artist: "
set /p "url=URL: "
set /p "type=Type (playlist/url): "
set /p "format=Format (mp3/mp4): "

:: === Output folder ===
set "output_dir=%USERPROFILE%\Downloads\%artist% - %title%"
if not exist "%output_dir%" (
    mkdir "%output_dir%"
)

:: === Common yt-dlp options ===
set "common_opts=--no-mtime --no-live-from-start --ignore-errors"

:: === Main download logic ===
if /i "%type%"=="url" (
    if /i "%format%"=="mp3" (
        yt-dlp.exe %common_opts% -x --audio-format mp3 --audio-quality 0 ^
            --embed-thumbnail --embed-metadata --add-metadata ^
            -o "%output_dir%\%%(title)s - %artist%.%%(ext)s" "%url%"
    ) else if /i "%format%"=="mp4" (
        yt-dlp.exe %common_opts% -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" ^
            --merge-output-format mp4 --embed-thumbnail --embed-metadata ^
            -o "%output_dir%\%%(title)s - %%(channel)s.%%(ext)s" "%url%"
    ) else (
        echo [ERROR] Invalid format. Use only mp3 or mp4.
        pause
        exit /b
    )
) else if /i "%type%"=="playlist" (
    if /i "%format%"=="mp3" (
        yt-dlp.exe %common_opts% -x --audio-format mp3 --audio-quality 0 ^
            --embed-thumbnail --embed-metadata --add-metadata ^
            -o "%output_dir%\%%(playlist_index)02d - %%(title)s - %artist%.%%(ext)s" "%url%"
    ) else if /i "%format%"=="mp4" (
        yt-dlp.exe %common_opts% -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" ^
            --merge-output-format mp4 --embed-thumbnail --embed-metadata ^
            -o "%output_dir%\%%(playlist_index)02d - %%(title)s - %%(channel)s.%%(ext)s" "%url%"
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
