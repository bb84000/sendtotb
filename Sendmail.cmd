:: Command script to replace the SendTo Recipient command for Thunderbird
:: Customized with signature
:: Change the thunderbird path if needed

@echo off

set args=%1
set thunderpath=C:\Program Files\Mozilla Thunderbird\Thunderbird.exe
:: Check if path exists

if not exist "%thunderpath%" (
echo Chemin de l'executable de Thunderbird inconnu
pause
exit
)

set name=%1
call:ExtractFileName name
set sargs= %name%

set BR="<br>"
set bargs="%sargs%"
set compteur=1 

shift
:boucle
if [%1] == [] goto done
set args=%args%,%1

set name=%1
call:ExtractFileName name

:: Increment counter
set /A compteur=%compteur%+1
set compteur 

:: Create file lists comma separated for subject, line feed for body
set sargs=%sargs%, %name%
set bargs=%bargs% %BR% "%name%"
shift
goto boucle

:done

set begbody=Bonjour %BR% %BR% Veuillez trouver ci-joint le fichier %BR% %BR%
if %compteur% EQU 1 GOTO equ1
set begbody=Bonjour %BR% %BR% Veuillez trouver ci-joints les fichiers %BR% %BR%

:equ1

set fargs=-compose attachment='%args%',subject='Envoi de fichiers: "%sargs%"',body='%begbody% %bargs% %BR% %BR% %USERNAME%'


start "" "%thunderpath%" %fargs%

exit

:ExtractFileName
FOR /F "delims=" %%i IN ("%name%") DO (
set name=%%~ni%%~xi
)
exit /B