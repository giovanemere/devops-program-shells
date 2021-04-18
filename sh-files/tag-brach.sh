#!/bin/bash
SourceRepo="$1"     #Folder WorkSapace /var/lib/jenkins/jobs/DevSecOps/jobs/Folder_MFT_Common/jobs/Job_Build_Repos
ChangeNumber="$2"   #Se obtine el numero de cambio
UriGit1="$3"        #Se obtiene el usuario de conexion de bitbucket
UriGit2="$4"        #Se obtiene la URL del reposoritorio
PasswordGit="$5"    #Se obtiene password almacenado en jenkins
StablePoint="$6"

echo "SourceRepo :[$SourceRepo] ChangeNumber : [$ChangeNumber] UriGit1 : [$UriGit1] UriGit2 : [$UriGit2] PasswordGit : [$PasswordGit]  StablePoint : [$StablePoint]"
printf "\n"

if [ -z "$ChangeNumber" ]
then
      echo "Falta Numero de Cambio "
      exit 1
else
        echo "Continuar git diff y tag $ChangeNumber"

        #Update Artefacts
        git -C $SourceRepo pull $UriGit1:$PasswordGit$UriGit2

        #Chane Fetaure Update Folder Artefacts
        git -C $SourceRepo checkout feature/${ChangeNumber}

        #Crear Carpeta Artefactos
        [ -d $SourceRepo/$ChangeNumber ] && echo 'folder exist: 1' || mkdir -p $SourceRepo/$ChangeNumber

        ####
        #Seccion Tag
        #Obtener Ultimo Punto Stable Git log
        Pattern_change_number="$ChangeNumber-*"
        Temp_Stable_Point=$(git tag -l ${PattStablePoint} | sort --version-sort --reverse | head -1 | cut -d "-" -f2)
        StablePoint=$Temp_Stable_Point
        echo "StablePoint : $StablePoint"

        #Listar los artefactos del ultimo commit
        echo "git -C $SourceRepo diff --name-only "feature/$ChangeNumber"..$StablePoint | grep ".xml" |xargs cp --parents -t $SourceRepo/$ChangeNumber/ |xargs ls -ltr $SourceRepo/$ChangeNumber/"

        #List Artifacts
        git -C $SourceRepo diff --name-only "feature/$ChangeNumber"..$StablePoint | grep ".xml" 

        #Diferencial Artifacts Feature y Ultimo Punto Estable
        git -C $SourceRepo diff --name-only "feature/$ChangeNumber"..$StablePoint | grep ".xml" | xargs cp --parents -t $SourceRepo/$ChangeNumber/ | xargs ls -ltr $SourceRepo/$ChangeNumber/

        #Generamos siguiente tag
        Temp_Stable_Point=$(git tag -l ${Pattern_change_number} | sort --version-sort --field-separator=- --reverse | head -1 | cut -d "-" -f2)
        SumNextTag=$(expr $Temp_Stable_Point + 1)
        echo $SumNextTag
        NextComp="-"
        NextTagName="$ChangeNumber$NextComp$SumNextTag"
        echo $NextTagName

        #Almacenar Variable NextTagName en carpetas vars
        echo $NextTagName >$SourceRepo/Shells/vars/$ChangeNumber

        #Obtener Ultimo Tag
        git -C $SourceRepo tag -l $StablePoint | sort --version-sort --reverse | head -1 | cut -d "-" -f2

        #Generar Tag
        git -C $SourceRepo tag $NextTagName -m $ChangeNumber

        #URL Bitbucket Externo
        git -C $SourceRepo push $UriGit1:$PasswordGit$UriGit2 $NextTagName feature/$ChangeNumber

        #Listar Artefactos
        find $SourceRepo/$ChangeNumber/ -name *.xml
        printf "\n"
fi



