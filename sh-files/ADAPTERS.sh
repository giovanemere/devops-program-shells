#!/bin/bash
clear
#cd ${p:environment/originPath} 
sourceFolder="$1"
artifacType="$2"
passphrase="$3"
listArtifacType="list"$artifacType".txt"

# Metodo de Importacion
importArtifact(){
 export pathArtifact="$1" #[artifacType]
 export fileXML="$2" # [artefacto.xml]
 export artifactLog="$3" #[artefacto.log]
 export SFGInstall="/Sterling/B2B/install/tp_import/import.sh"
 export passphrase="$4"
 export pathdeploy=$sourceFolder/$pathArtifact
  
sh $SFGInstall -input $pathdeploy/$fileXML -update -backup $sourceFolder/Backup/$pathArtifact/$fileXML -report $sourceFolder/Report/$pathArtifact/$artifactLog -errors $sourceFolder/Errors/$pathArtifact/$artifactLog -passphrase $passphrase 

}

cd $sourceFolder
echo  'Source Folder: ['$sourceFolder']'
echo  'Desplegando: ['$artifacType']'

if [ -d $artifacType/ ]; 
then
	count="$( find ./$artifacType/ -type f -name '*.xml' -o -name '*.XML' | wc -l )"
	
	if [ $count -eq 0 ] ;
		then 
			echo '>> Warning: No existen artefactos [xml|XML] en ['$artifacType']'
	else
		cd $sourceFolder
		echo 'Existen ['$count'] artefactos en ['$artifacType']'
		#Archivo aux
		touch ./$artifacType/$listArtifacType
		if [ $(echo $?) -eq 1 ]
		then
		    exit 1
		fi
		#Se enlista archivos xml en el archivo aux
		ls ./$artifacType/ | egrep '\.xml$|\.XML$' > ./$artifacType/$listArtifacType
		if [ $(echo $?) -eq 1 ]
		then
		   exit 1
		fi
		#Se crean carpetas aux
		mkdir -p ./Report/$artifacType ./Backup/$artifacType ./Errors/$artifacType
        if [ $(echo $?) -eq 1 ]
		then
		   exit 1
		fi
		
        aux=1
		while read fileXML  #lee archivo de texto $listArtifacType
		do
			cd $sourceFolder/$artifacType
					
			#Despliegue por artefacto
			echo '---------------------------------------------------------------------'
			echo 'Desplegando Artefacto: ['$artifacType'|'$fileXML'] ('$aux'/'$count')-'
		    artifactLog="${fileXML%.xml}"
			artifactLog=$artifactLog.log
		    importArtifact $artifacType $fileXML $artifactLog $passphrase
			log_error=$sourceFolder/Errors/$artifacType/$artifactLog
			log_report=$sourceFolder/Report/$artifacType/$artifactLog
			
			#Incia proceso de escritura de logs
			cd $sourceFolder/$artifacType 
		    cat -b $log_report
            
			if [ $(echo $?) -eq 2 ]; # Si no puede abrir el .log entonces arroja error
			 then
                exit 1
            else
				if [ -f "$log_report" ]; then
					if [ $(grep -c -E "ERROR|already exists"  $log_report) -gt 0 ]; then
						grep -w -i -E "ERROR|already exists"  $log_report >> $log_error
						rm -rf $sourceFolder/$artifacType/$listArtifacType 
						## Recuerde Borrar
						#exit 1
					fi
				else
						echo "No se encuentra Archivo : $log_report" >> $log_error
				fi	
            fi
            
            if [ -f $log_error ]
			 then
                echo '- >>> '$artifacType'/'$fileXML' [IMPORT FAILED]'
                exit 1
            else 
                echo '- >>> '$artifacType'/'$fileXML' [IMPORT OK]'
            fi
		    ((aux++))

    	done < ./$artifacType/$listArtifacType
		
		rm -rf $sourceFolder/$artifacType/$listArtifacType

	fi
else
	echo '> > > La carpeta [' $artifacType '] no existe! < < <'
	exit 0
fi
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo  '---------------------------------------------------------------------'
echo  '>>> Despliegue de [ '$count' | '$artifacType' ] FINALIZADO! <<<'
echo  '--------------------------------------------------------------------'
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
