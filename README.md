## Creacion y Desacople de groovy
- Se desacopla del pipeline la notificación de creación y edición de Issues desde un Jenkinsfile para su reutilizacion
 
### Ejemplos
- Creación Issues
 
``` bash
node{
    
    stage('Create Issue'){
        def issue = [fields:[project:[key: "${jira_project_key}"],
            summary: "feature-C${envCHANGE_NUMBER}",
            description: "Edited task feature-C${envCHANGE_NUMBER} automatically from Jenkins Build Numer: ${BUILD_NUMBER}",
            issuetype:[name: 'Task']]]
        
        def newIssue = jiraNewIssue issue: issue, site: 'Jira'
            echo newIssue.data.key
           echo "summary: ${issue.fields.summary}"
    }
    
}
```
 
- Edición Issues
 
``` bash
stage('Edit Description Issue') {
    
     
      def testIssue = [fields: [ project: [key: "${jira_project_key}"],
                                 summary: "feature-C${envCHANGE_NUMBER}",
                                 description: 'Detalle de la Descripcion',
                                 issuetype: [name: 'Task']]]
 
      response = jiraEditIssue idOrKey: "${key}", issue: testIssue
      echo response.successful.toString()
      echo response.data.toString()
    
    }
```
 
- Otros Ejemplos:
 
``` bash
stage('Assign Issue') {
      jiraAssignIssue idOrKey: "${key}", userName: 's6882169'
    }
    
    stage('Add Comment') {
      jiraAddComment idOrKey: "${key}", comment:"DEPLOY C12345-1.1 SUCCESFUL ${BUILD_URL}/display/redirect"
    }
    
    stage('Update Status') {
      def transitionInput = [transition: [id: '31']]
      jiraTransitionIssue idOrKey: "${key}", input: transitionInput
    }
 
