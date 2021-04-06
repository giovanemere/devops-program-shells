#!/bin/bash
clear

-- Revisar ejecicio partner

query
#1.  Canales 1 , 
#2.  Templates 0,
#3.  Grupos 1,
#4.  Code List 1,  
#5.  Partner 1,
#6.  perfil SSH 1,  ---
#7.  Schedules ,  ----
#8.  BP 1,   ----
#9.  Certificados 1,   ---
#10. XSLT 1,    ---
#11. ObcureData 1,   ---
#12. Adaptadores 1 ,  ---
#13. Comunidad 1, 

#Al llamar este shell 
#sh /Sterling/import/Shells/rollback.sh Artifact_115 PARTNERS Migra2019

#Varables de Orquestador
sourceFolder=/Sterling/import/$1/Backup
PathShells=/Sterling/import/Shells
ARTEFACT="$2"
PASSPHARASE="$3"

#Ajustar permisos de carpeta Artifacts
#chmod -R 755 $sourceFolder

echo "sourceFolder :{$1} Artefact : {$ARTEFACT}  "

cd $PathShells
#Inicia Proceso de Despliegue
echo '\n*********************************************************************************'
echo 'Rollback Despliegue STERLING'
echo '\n*********************************************************************************'

scriptPARTNERS="sh $PathShells/component-rollback.sh "$sourceFolder" "$ARTEFACT" "$PASSPHARASE" "
$scriptPARTNERS



