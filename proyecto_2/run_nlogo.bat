@echo off

rem Cambiar el classpath a su instalacion de netlogo
set CLASSPATH=C:\Program Files (x86)\NetLogo 5.1.0\NetLogo.jar;.

set HEADER="enable-growth,enable-replicative-cap,enable-apoptosis,enable-metastasis,growth-sensibility,replicative-sensibility,apoptosis-max-gen,cell-size,cancer,normal,metastasis-count"

echo %HEADER% > cancer.csv

rem Darle mas RAM para que corra mas rapido
java -Xmx1024m -Dfile.encoding=UTF-8 org.nlogo.headless.Main --model proyecto.nlogo --setup-file experiments.xml
