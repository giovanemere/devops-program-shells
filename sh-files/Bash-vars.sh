#!/bin/bash

#   VARNAME_VALUE          WORKSPACE                                                  FOLDERVARS VARNAME
#echo "C12345" > "~/jobs/Sterling-Deploy-Automate/jobs/Sterling-Unified-Build/workspace/Shells/vars/change_number.var"

#Variables de uso Global
WORKSPACE="$1"
FOLDERVARS="$2"
VARNAME="$3"
VARNAME_VALUE="$4"

echo "WORKSPACE :[$WORKSPACE]  VARNAME : [$VARNAME]  VARNAME_VALUE : [$VARNAME_VALUE] "

#Variable uso de Concatenación del proceso de versionamiento y Despliegue
echo "$VARNAME_VALUE" > "$WORKSPACE"/"$FOLDERVARS"/"$VARNAME"

ls "$WORKSPACE"/"$FOLDERVARS"/"$VARNAME"


