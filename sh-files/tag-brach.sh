#!/bin/bash
# echo "$1" #:: Ruta repositorio local = #WORKSPACE
# echo "$2" #:: change_number
#     #htps://bitbucket.agile.bns/scm/rcmcol/devops-release.git
#     #htps://eduart-doria@bitbucket.org/eduart-doria/sfg_proc_00056.git
# echo "$3" #:: Owner repositorio = eduart-doria
# echo "$4" #:: NombreRepositorio = sfg_proc_00056
# echo "$5" #:: Usuario
# echo "$6" #:: Password
# echo "$7" #:: tag

SourceRepo="$1"
ChangeNumber="$2"
UriGit1="$3"
UriGit2="$4"
PasswordGit="$5"
NumTag="$6"

echo "SourceRepo :[$SourceRepo] ChangeNumber : [$ChangeNumber] UriGit1 : [$UriGit1] UriGit2 : [$UriGit2] PasswordGit : [$PasswordGit] NumTag : [$NumTag]"
printf "\n"

git -C $SourceRepo pull $UriGit1:$PasswordGit$UriGit2

git -C $SourceRepo tag $NumTag -m $ChangeNumber
printf "\n"

#URL Bitbucket Externo
git -C $SourceRepo push $UriGit1:$PasswordGit$UriGit2 $NumTag #feature/$ChangeNumber 
                        
#URL Colpatria
#echo "git -C $1 push https://$UserGit:$PasswordGit@bitbucket.agile.bns/scm/$OwnerRepository/$NameRepository.git $NumTag feature/$ChangeNumber "
#echo "git -C $SourceRepo push https://$UserGit:$PasswordGit@bitbucket.org/$OwnerRepository/$NameRepository.git $NumTag feature/$ChangeNumber "
