REM start mysql daemon/service
start "mysql" mysqld.exe

REM create database instruction file
echo CREATE DATABASE drupal;> spn_cmd.txt
REM create coutn variable for retries
set spn_temp_count=0

REM create database
:createDB
REM increment count
set /A spn_temp_count=%spn_temp_count%+1
REM sleep for 5 seconds
ping -n 6 127.0.0.1 > nul
REM pass database instruction file to toecho %ERR mysql
mysql -u root < spn_cmd.txt
REM if this fails more than 5 times, then fail the setup
IF %spn_temp_count% GEQ 6 GOTO fail
REM if this succeeds, no need to retry
IF %ERRORLEVEL% 0 GOTO succeed
REM retry
goto createDB

REM issue exit code on failure
:fail
echo MySQL setup failed.
exit /b 1

REM clean up and shutdown on success
:succeed
echo MySQL setup succeeded.
del spn_cmd.txt
mysqladmin.exe -u root shutdown