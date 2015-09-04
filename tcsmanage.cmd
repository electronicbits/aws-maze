@ECHO OFF
IF "%1"=="install" GOTO install
IF "%1"=="uninstall" GOTO uninstall
IF "%1"=="start" GOTO start
IF "%1"=="stop" GOTO stop
GOTO end

:install
SETX TEAMCITY_DATA_PATH C:\TeamCityServerData /m
XCOPY C:\TeamCity-9.1.1\TeamCity C:\TeamCityServer /s /q /i
NETSH advfirewall firewall add rule name="TeamCity Server" dir=in action=allow protocol=TCP localport=80
REM CALL C:\TeamCityServer\bin\teamcity-server service install /runAsSystem
CALL C:\TeamCityServer\bin\runAll.bat start
GOTO end

:uninstall
CALL C:\TeamCityServer\bin\teamcity-server service delete
NETSH advfirewall firewall delete rule name="TeamCity Server"
RMDIR /s /q C:\TeamCityServer
GOTO end

:start
NET start TeamCity
GOTO end

:stop
NET stop TeamCity
GOTO end

:end