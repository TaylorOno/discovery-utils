@echo off

SET "datadir=%CD%"
SET "datadir=%datadir:\=/%"

IF [%1]==[/?] GOTO :help

IF [%1]==[/r] GOTO :removeImage

echo %* |find "/?" > nul
IF errorlevel 1 GOTO :main

:help
ECHO Usage: %0 [option...]
ECHO Usage: %0 [parm 1] [parm 2]
ECHO Example %0 parm1 parm2
ECHO Tool Description
ECHO
ECHO    /r                      This will refresh discovery-couchbase docker image
ECHO                            (Only needed if the discovery-couchbase Version has changed
ECHO
GOTO :end

:removeImage
docker image rm -f discovery-couchbase
SET REFRESH="1"

:checkBase
FOR /F %%i IN ('docker images -q discovery-couchbase') DO (
    ECHO Found discovery-couchbase image
    GOTO :main
)

CD Docker

docker build -t discovery-couchbase:latest -f Dockerfile .
IF [%REFRESH%] == ["1"] GOTO :end

:main

docker run -d ^
--name discovery-couchbase ^
-p 8091-8094:8091-8094 ^
-p 11210:11210 ^
-v "%datadir%/.datafiles:/opt/couchbase/var" ^
discovery-couchbase >nul 2>&1

IF ERRORLEVEL 125 GOTO startContainer
ECHO "creating container discovery-couchbase this may a minute to initialize"
GOTO end

:startContainer
ECHO "starting container discovery-couchbase"
docker start discovery-couchbase

:end
cd %datadir%