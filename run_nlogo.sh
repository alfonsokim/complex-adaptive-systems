!#/bin/bash

export CLASSPATH=/Applications/NetLogo\ 5.1.0/NetLogo.jar:.

java -Xmx1024m -Dfile.encoding=UTF-8 org.nlogo.headless.Main --model proyecto_1.nlogo --setup-file experiments.xml
