#!/bin/bash
#Autor: AOS SAS zuniedis
#Descripción: Programa para comprimir y descomprimir archivos
#Ejecución: 
#'Tipo:['${1}'] PathFolderIn:['${2}'] Filename:['${3}'] Accion:['${4}']'
#./util-compress.sh /bin/tar Compress /var/lib/jenkins/jobs/Sterling-Deploy-Automate/jobs/Sterling-Programs-Build/workspace /var/lib/jenkins/jobs/Sterling-Deploy-Automate/jobs/Sterling-Programs-Build/workspace Shells_41.tar zFile "*.sh"
#==============================================================================
# Constantes
#------------------------------------------------------------------------------
readonly Compress=Compress #Compress $1
readonly Decompress=Decompress #Descompress $1
readonly File=File #Tipo Archivo  $1
readonly zFile=zFile #Tipo Archivo Zip $1
readonly Folder=Folder #Tipo Folder $1
readonly dFile=dFile #Todos los archivos $1
#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
PgmZip=$1
Tipo=$2
PathFolderIn=$3
WorkspaceArt=$4
Filename=$5
Accion=$6
PgmPattern=$7
#------------------------------------------------------------------------------
# Variables Dinamicas
#------------------------------------------------------------------------------
FilenameZip=$Filename.zip
FilenameTar=$Filename.tar
#------------------------------------------------------------------------------
# Funciones
#------------------------------------------------------------------------------
ValidaTipo(){
rcv=0
  case $Tipo in #Valida Zip o Unzip
    $Compress)
                rcv=0
    ;;
    $Decompress)
                rcv=0
    ;;
    *)
                rcv=1
    ;;
  esac
  return $rcv
}
#------------------------------------------------------------------------------
ValidaAccion(){
rcv=0
  case $Accion in #Valida uno o varios o todos Archivos o Folder  
    $File)
                rcv=0
    ;;
    $zFile)
                rcv=0
    ;;
    $Folder)
                rcv=0
    ;;
    $dFile)
                rcv=0
    ;;
    *)
                rcv=1
    ;;
  esac
  return $rcv
}

Compress_File(){
echo "Nombre de Archivo ZIP: $Filename.zip"
cd $PathFolderIn
${PgmZip} -rvf "$Filename" --files-from -
if [ $? -eq 0 ]; then
  echo "!!! Comprimido Exitoso, ruta : $PathFolderIn ¡¡¡"
else
  echo ">>> Error en el proceso de compresion del archivo $Filename. <<<"
fi
}

Compress_Files(){
echo "zip varios archivos"
cd $PathFolderIn/
pwd
find . -maxdepth 3 -type f -name "$PgmPattern" | sed 's/^\.\///g' | ${PgmZip} -rvf $Filename --files-from -
if [ $? -eq 0 ]; then
    ls -ltr $PathFolderIn/$Filename
    chmod 705 $PathFolderIn/$Filename
    echo "!!! $NameFolder Comprimido Exitoso, ruta : $PathFolderIn/$Filename ¡¡¡"
else
  echo ">>> Error en el proceso de compresion de Archivos. <<<"
fi
}

Compress_Folder(){
echo "zip Folder"
cd $PathFolderIn/
pwd
echo "${PgmZip} -cvf $Filename $WorkspaceArt"

${PgmZip} -cvf "$Filename" "$WorkspaceArt"
if [ $? -eq 0 ]; then
    ls -ltr "$PathFolderIn"/"$Filename"
    echo "!!! $NameFolder Comprimido Exitoso, ruta : $WorkspaceArt/$Filename ¡¡¡"
else
  echo ">>> Error en el proceso de compresion de las carpetas del folder $WorkspaceArt. <<<"
fi
}

Descompress_file(){
echo "descrompirmir 1 archivo"
cd $PathFolderIn/
${PgmZip} -xvf $Filename
if [ $? -eq 0 ]; then
  echo "!!! $Filename Descomprimido Exitoso, ruta : $PathFolderIn ¡¡¡"
else
  echo ">>> Error en el proceso de descompresion del archivo $Filename. <<<"
fi
}

#==============================================================================
# Proceso Principal
#==============================================================================
clear
echo 'PgmZip:['${PgmZip}'] Tipo:['${Tipo}'] PathFolderIn:['${PathFolderIn}'] WorkspaceArt:['${WorkspaceArt}'] Filename:['${Filename}'] Accion:['${Accion}'] PgmPattern:['${PgmPattern}']'

if [ $# -lt 7 ]; then
  echo "El numero de parametros no es correcto."
  exit 0
else
  Tipo=$Tipo
  PathFolderIn=$PathFolderIn
fi

#Valida el tipo de archivo
ValidaTipo $Tipo
if [ $? -ne 0 ]; then
  echo "Parametro de Tipo distinto a (Compress o Decompress). " $Tipo
  exit 0
fi

#Valida el tipo de Acción ENC o DEC
ValidaAccion $Accion
if [ $? -ne 0 ]; then
  echo "Parametro de Accion distinto a los registrados. " $Accion
  exit 0
fi

#Proceso principal
case $Tipo in
    $Compress) 
      case $Accion in
      $File)
      Compress_File
      ;;
      $zFile)
      Compress_Files
      ;;
      $Folder)
      Compress_Folder
      ;;
    esac
    ;;
    $Decompress)
      case $Accion in
      $dFile)
      Descompress_file
      ;;
              esac
  ;;
esac

#==============================================================================
echo " Fin Ejecucion del Programa "
#==============================================================================
