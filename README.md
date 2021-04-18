## Creacion y Desacople de groovy
- Se desacopla del pipeline la notificación de creación y edición de Issues desde un Jenkinsfile para su reutilizacion
 
### Ejemplos
 
- Asignación de las variables de entorno:
 
``` bash
stage ('Job Variables Build') {
        steps {
            script
                {       
                //extrae nombre JOb
                env.NombreJobWork = ComTempWork.substring(0,ComTempWork.lastIndexOf('/'))
                env.TempWorkSpace = NombreJobWork.substring(0,NombreJobWork.lastIndexOf('/'))
                env.BrachGit = ComBrachGit.substring(ComBrachGit.indexOf('/')+1)

                //Variables Dinamicas                        
                env.TypeEnvironment= "${env.BrachGit}" //Develop/Release/Production //Revisar como sacar del git
                env.TypeEnvironmentSSH = "${env.BrachGit}" //Develop/UAT/PRDN1/PRDN1 //Revisar como sacar del git                        
                
                env.Job_Copy = "${Job_Name_SSH_Copy}_${env.TypeEnvironmentSSH}"
                env.TmpWorkJobCopyWorkspace = "${TempWorkSpace}/${env.Job_Copy}/workspace"                                                
            }                            
        } 
} 
```
 
- Descripción: Generación del archivo Tar con los fuentes del repositorio.
 
``` bash     
stage('Job Build Repos') {
steps {
        script {
          build job: "${Path_Job_Common}/${Job_Name_Build}", parameters: [
                        string(name: 'AntUriGit', value: "$UriGit"),
                        string(name: 'AntUserIDGit', value: "$UserIDGit"),
                        string(name: 'AntBrachGit', value: "$env.BrachGit"),
                        string(name: 'AntPgmPattern', value: "$PgmPattern"),
                        string(name: 'AntAccion', value: "$Accion"),
                        string(name: 'AntTmpWokJobMasterRepos', value: "$WORKSPACE"),
                        string(name: 'AntTipo', value: "$Tipo")
                        ]                                
                        //Parameters Upload
                        env.FileTar = sh (script: 'cat $WORKSPACE/$PathFolderVars/$VarName', returnStdout: true).trim()
                        sh 'echo "${FileTar}"'

                        env.FileBuild = FileTar.substring(0,FileTar.indexOf('.'))
                        sh 'echo "${FileBuild}"'

                        sh 'cat $WORKSPACE/$PathFolderVars/$VarName'
                }
        }
        post {
        success {                                
                        //Completo Satisfactoriamente
                        echo "Sub Job Build Repos: ${env.BrachGit} Sucessfully"
                }
        failure {
                        //Fallo Job revisar Ejecución en el Job Interno
                        echo "Failed Job Build Repos"
                        }
                }

        } 
```
 
- Descripción: Cargar archivo Tar a JFrog Artifctory con los artefactos del cambio a desplegar
 
``` bash    
stage('Job Jfrog Upload') {
steps {
        script {
                build job: "${Path_Job_Common}/${Job_Name_Jfrog_Upload}", parameters: [
                        string(name: 'AntTempWorkspace', value: "$Job_Name_Build"),
                        string(name: 'AntFileTar', value: "$FileTar"),
                        string(name: 'AntProject_Name', value: "$Project_Name"),
                        string(name: 'AntTypeEnvironment', value: "$TypeEnvironment"),
                        string(name: 'AntPattern', value: "$Pattern")
                        ]
                }
        }
        post {
        success {
                        //Completo Satisfactoriamente
                        echo "Sub Job Jfrog Upload: ${FileTar} Sucessfully"

                }
        failure {
                        //Fallo Job revisar Ejecución en el Job Interno
                        echo "Failed Sub Job Jfrog Upload"
                }
        }
} 
```
 
- Descripción: Recuperación del archivo Tar de JFrog Artifactory que contiene los artefactos del cambio a desplegar
 
``` bash    
stage('Job Jfrog Download') {
steps {
        script  {
                build job: "${Path_Job_Common}/${Job_Name_Jfrog_Download}", parameters: [
                        string(name: 'AntFileBuild', value: "$FileBuild"),
                        string(name: 'AntTempWorkspace', value: "$Job_Name_Build"),
                        string(name: 'AntFileTar', value: "$FileTar"),
                        string(name: 'AntProject_Name', value: "$Project_Name"),
                        string(name: 'AntTypeEnvironment', value: "$TypeEnvironment"),
                        string(name: 'AntSourceFiles', value: "$Pattern"),
                        string(name: 'AntRemoteDirectory', value: "$RemoteDirectory"),
                        string(name: 'AntJob_Copy', value: "$Job_Copy"),
                        string(name: 'AntTmpWorkJobCopyWorkspace', value: "${TmpWorkJobCopyWorkspace}"),
                        string(name: 'AntTypeEnvironmentSSH', value: "$TypeEnvironmentSSH")
                        ]
                }
        }
        post {
        success {
                        //Completo Satisfactoriamente
                        echo "Sub Job Jfrog Download: ${FileBuild} Sucessfully"
                }
        failure {
                        //Fallo Job revisar Ejecución en el Job Interno
                        echo "Failed Sub Job Jfrog Download"
                }
        }
} 
```
 
- Descripción: Copia del archivo Tar en el servidor en el que se realizará el despliegue
 
``` bash    
stage("Job Copy Artifacts SSH") {
        steps {
                build job: "${Job_Copy}", parameters: [
                string(name: 'AntSourceFiles', value: "${Pattern}"),
                string(name: 'AntRemoteDirectory', value: "${RemoteDirectory}")
                ]
        }
        post {
                success {
                                //Completo Satisfactoriamente
                                echo "Sub Job Copy Artifacts SSH: ${RemoteDirectory} Sucessfully"
                          }
                failure {
                                //Fallo Job revisar Ejecución en el Job Interno
                                echo "Failed Sub Job Copy Artifacts SSH"
                }
        }
} 
```
 
- Descripción: Ejecución de los scripts que realizan los despliegues en el servidor de Sterling.
 
``` bash    
stage("Job SSH Deploy Sterling") {
        steps {
                build job: "${Job_Name_SSH_Deploy}" , wait: true
        }
        post {
                success {
                                //Completo Satisfactoriamente
                                echo "Sub Job SSH Deploy Sterling: Sucessfully"
                          }
                failure {
                                //Fallo Job revisar Ejecución en el Job Interno
                                sh 'rm -rf ${TmpWorkJobCopyWorkspace}/*'
                                echo "Failed Sub Job SSH Deploy Sterling"
                }
        }
} 
```
 
- Descripción:
 
``` bash    
stage ('Removing files') {
        steps {
            script
                { 
                    //Clean WORKSPACE Job
                    sh 'rm -rf $WORKSPACE/*'
                    sh 'rm -rf ${TmpWorkJobCopyWorkspace}*'
            }                            
        }
        post {
            success {
                        //Completo Satisfactoriamente
                        echo "Cleanup Enviroment  Sucessfully"
                    }
            failure {
                        //Fallo Job revisar Ejecución en el Job Interno
                        echo "Failed Cleanup Enviroment "
                }
        }
}
 
```


