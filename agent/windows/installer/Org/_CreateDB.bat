@echo off
SETLOCAL
set Company=ActiveState

rem Path to the product folder: 
set ProductPath=.\src\ActiveProduct

set ProductName=ActiveProduct
set MSI_Version=1.0.0.1905
set Version_Name=Beta 1

rem path to the "msival2.exe":
set ValidatorPath=%ProgramFiles%\MsiVal2

rem Where to get files for copying to the product folder:
rem set FileSourceRoot=..\..\..\..\VisualStudio
set FileSourceRoot=

rem Path where to copy *.msi:
rem set QA_Path=

rem ****************************************************************************
IF NOT EXIST .\OUTPUT MKDIR .\OUTPUT

CALL %WizardPath%msiwiz.pl "%Company%" "%ProductPath%" "%ProductName%" "%MSI_Version%" "%Version_Name%" "%FileSourceRoot%"
pause


