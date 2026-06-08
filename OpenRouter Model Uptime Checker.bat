@echo off
setlocal EnableDelayedExpansion

rem Prompt for a comma-separated list of author/slug entries
set /p AUTHOR_SLUGS=Enter AUTHOR_SLUGs (comma-separated, e.g., minimax/minimax-m2.5:free, nvidia/nemotron-3-super-120b-a12b:free): 
set API_KEY=

rem Convert commas to spaces so we can iterate with a FOR loop
set "SLUG_LIST=%AUTHOR_SLUGS:,= %"

rem Process each slug
for %%S in (%SLUG_LIST%) do (
    set "CURRENT_SLUG=%%S"
    rem Remove leading/trailing spaces
    for /f "tokens=* delims= " %%T in ("!CURRENT_SLUG!") do set "CLEAN_SLUG=%%T"
    
    rem Build a safe filename: replace '/' and ':' with '_'
    set "FILENAME=OpenRouterUptimeChecker_!CLEAN_SLUG:/=_!"
    set "FILENAME=!FILENAME::=_!.json"
    
    echo Processing !CLEAN_SLUG! -> !FILENAME!
    curl https://openrouter.ai/api/v1/models/!CLEAN_SLUG!/endpoints -H "Authorization: Bearer %API_KEY%" -v -o "!FILENAME!"
)

endlocal
pause