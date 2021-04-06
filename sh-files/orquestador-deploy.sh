#!/bin/bash
clear
#1.  Comunidad, - Se estan desplegando por configuración y no aplicaria para el modulo de automatización
#2.  Adaptadores, - CARPETA ADAPTERS
#3.  ObcureData,  - CARPETA OBSCUREDATA
#4.  XSLT,        - CARPETA XSLT
#5.  Certificados,- CARPETA CERTIFICATES
#6.  BP,          - CARPETA BUSINESS_PROCESS
#7.  Schedules,   - CARPETA SCHEDULES
#8.  perfil SSH,  - CARPETA SSH_PROFILES
#9.  Partner      - CARPETA PARTNERS
#10. Code List    - CARPETA CODE_LISTS
#11. Grupos       - CARPETA GROUPS
#12. Templates,   - CARPETA TEMPLATES
#13. Canales      - CARPETA ROUTING_CHANNELS

#Al llamar este shell 
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "ADAPTERS" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "OBSCUREDATA" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "XSLT" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "CERTIFICATES" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "BUSINESS_PROCESS" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "SCHEDULES" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "SSH_PROFILES" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "SCHEDULES" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "PARTNERS" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "CODE_LISTS" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "GROUPS" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "TEMPLATES" "Migra2019"
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "ROUTING_CHANNELS" "Migra2019"

# Jenkinsfile
# //                  1                 2            3           4
#sh './$OrqShell "$WORKSPACE"   "$workDirRemote" "ADAPTERS" "$PwdImport"'
#                 $SourceShells                   "Artefact"             

#Varables d"e" Orquestador"/Sterling/import" "
SourceShells="$1"
workDirRemote="$2"
Artefact="$3"
Passphrase="$4"

#Ajustar permisos de carpeta Artifacts
#chmod -R 740 $workDirRemote

echo "workDirRemote :[$workDirRemote]  Artefact : [$Artefact]  Passphrase : [$Passphrase] "

echo "cd $SourceShells"
#Inicia Proceso de Despliegue
echo '\n*********************************************************************************'
echo 'Orquestador Despliegue STERLING'
echo '\n*********************************************************************************'

scriptPARTNERS="$SourceShells/$Artefact.sh "$workDirRemote" "$Artefact" "$Passphrase" "
$scriptPARTNERS
