def jiraNotification() {
    
    try{
                        
    def searchResults = jiraJqlSearch jql: "project = ${JiraProjectKey} AND summary ~ feature-${ChangeNumber}"
    def issues = searchResults.data.issues
    def key = issues[0].key
    
    echo searchResults.data.issues.summary.toString()

    // Look at IssueInput class for more information.
    def testIssue = [fields: [ project: [key: "${JiraProjectKey}"],
                                summary: "feature-${ChangeNumber}",
                                description: "Edited task feature-${ChangeNumber} automatically from Jenkins Build Numer: ${BUILD_NUMBER} ${BUILD_URL}/display/redirect",
                                issuetype: [name: 'Task']]]

    response = jiraEditIssue idOrKey: "${key}", issue: testIssue
    
    echo response.successful.toString()
    echo response.data.toString()

    echo "ISSUE EDITED"

    } catch(error){

        def issue = [fields:[project:[key:"${JiraProjectKey}"],
        summary: "feature-${ChangeNumber}",
        description: "Feature merged to release: feature-${ChangeNumber} Build Numer: ${BUILD_NUMBER} ${BUILD_URL}/display/redirect",
        issuetype:[name: 'Task']]]

        def newIssue = jiraNewIssue issue: issue, site: 'Jira'
            echo newIssue.data.key
            echo "summary: ${issue.fields.summary}"

        echo "ISSUE CREATED"
    }
}

return this