
#!/bin/bash

#echo ERROR >/Sterling/import/Artifact_115/Errors/TEMPLATES/prubeas.log
#echo dfsadsadsadsa >/Sterling/import/Artifact_115/Errors/TEMPLATES/prubeas.log

log_report=/Sterling/import/Artifact_115/Errors/TEMPLATES/prubeas.log

if [ -f "$log_report" ] && [ $(grep -c 'ERROR'  $log_report) -gt 0 ]; then
    grep -w -i 'ERROR'  $log_report > "$log_report"_1
    echo prueba6 
    exit 1
else
     echo pruebas7
fi



#if [ -f "$log_report" ] || grep -w -i 'ERROR'  $log_report > "$log_report"_1 ]; then