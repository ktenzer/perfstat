@echo off
SETLOCAL
set Company=PerfStat

rem Path to the product folder: 
set ProductPath=.\src\PERFSTAT

set ProductName=Client
set MSI_Version=1.0.0.1905
set Version_Name=1.50

rem path to the "msival2.exe":
set ValidatorPath=%ProgramFiles%\MsiVal2

rem Where to get files for copying to the product folder:
set FileSourceRoot=D:\PERFSTAT\WINDOWS\BUILD\1.50

rem Path where to copy *.msi:
rem set QA_Path=

rem ****************************************************************************
IF NOT EXIST .\OUTPUT MKDIR .\OUTPUT

CALL %WizardPath%msiwiz.pl "%Company%" "%ProductPath%" "%ProductName%" "%MSI_Version%" "%Version_Name%" "%FileSourceRoot%"
pause


