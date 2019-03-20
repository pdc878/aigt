:: Run this in the Anaconda Prompt

@echo OFF

if %1.==. goto No1

set CurrentPath=%cd%
set ProjectPath=%1
set EnvironmentPath=%ProjectPath%\Env

:: Create the environment and activate it

call conda create -y -n %EnvironmentPath% python=3.6
call activate %EnvironmentPath%

:: Installing non-problematic packages

call pip install tensorflow-gpu==1.10.0 keras==2.2.3 pandas==0.24.1
call conda install -y pillow=5.0 lxml=4.2 jupyter=1.0 matplotlib=2.2 opencv=3.3

call git clone -b pyIGTLink_client https://github.com/Sunderlandkyl/pyIGTLink.git %ProjectPath%\pyIGTLink
call pip install -e %ProjectPath%\pyIGTLink

:: Compile research modules, like for object detection
:: Executable only needed on Windows. protoc will work on Linux as installed. Todo: Create setup script for bash

call git clone https://github.com/tensorflow/models.git %ProjectPath%\models

set ScriptPath=%~dp0

cd %ProjectPath:~0,2%
cd %ProjectPath%\models\research

%ScriptPath%..\protoc-3.4.0-win32\bin\protoc.exe object_detection/protos/*.proto --python_out=.

cd %CurrentPath:~0,2%
cd %CurrentPath%

:: Installing keras-vis from source to get the latest bug fixes

cd %ProjectPath%

call git clone https://github.com/raghakot/keras-vis.git %ProjectPath%\keras-vis
cd keras-vis
call python setup.py install

cd %CurrentPath%

:: Exiting install script

GOTO End1

:No1
  echo.
  echo Usage: %~n0 PROJECT_PATH
  echo E.g.: %~n0 c:\MyProject
  echo.
  echo Note: If admin access is needed to write the environment path, then make sure to start this Anaconda Prompt in Administrator mode.
  echo.
goto End1

:End1