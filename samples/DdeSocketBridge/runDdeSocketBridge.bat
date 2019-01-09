echo off
if not exist "DdeSocketBridge.jar" goto :error
java -Djava.library.path=.\src\main\resources -jar DdeSocketBridge.jar
goto :end
:error
echo DdeSocketBridge.jar is not found
:end
