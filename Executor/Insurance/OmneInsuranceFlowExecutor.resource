*** Settings ***
Library     OperatingSystem
Library     AppiumLibrary
Library     Screenshot
Library     ../../Qrace/QraceHelper.py
Resource    ../../CustomLibraries/common.robot
Resource    ../../Pages/Insurance/Common/LoginPage.resource
Resource            ../../Pages/Insurance/UpdatePolicy/UpdatePoliciesmoduleSelectPage.resource
Resource            ../../Pages/Insurance/UpdatePolicy/PaymentMethodDetailsPage.resource
Resource            ../../Pages/Insurance/ViewPolicyInvestment/ViewPolicyDetailsPage.resource
Resource            ../../Executor/OWB/OWBExecutor.robot
Resource            ../../Executor/LA/LAExecutor.robot
Resource            ../../Executor/IL/IL_Executor.robot
Resource            ../../Executor/OPUS/OPUSExecutor.robot
Resource            OmneInsuranceFlowExecutor.resource
Resource            ../../Pages/Insurance/ViewTransaction/TransactionDetailsPage.resource
Resource            ../../Pages/Insurance/Claims/ClaimsPage.resource
Resource            ../../Pages/Insurance/PayPremium/LoanRepaymentPage.resource
Resource            ../../Pages/Engagement/EngagementQuicklinkPage.robot
Resource            ../../Pages/Engagement/EngagementBannerPage.robot
Resource            ../../Pages/Insurance/ViewDocument/ViewDocumentModulePage.resource
Resource            ../../Pages/Insurance/UpdatePolicy/BenefitPayoutPage.resource
Resource            ../../Pages/Insurance/UpdatePolicy/PremiumpaymentHistoryPage.resource
Resource            ../../Pages/Insurance/Common/ForgotMPIN.resource
Resource    ../OWB/OWBExecutor.robot
Resource        ../../Pages/Insurance/TrueOnbording/TrueOnboardingPage.resource
Resource        ../../Pages/Insurance/PayorOnbording/PayorOnboardingPage.resource
Library     Mainframe3270
Resource    ../LA/LAExecutor.robot
Resource    ../../CustomLibraries/Operation.py





*** Variables ***
${actualResult}
${testjobId}
${screenshotDir}
${testCaseId}
${udid}
${owbactualResult}
${VP_Transaction_Status}
${deviceName}
${platformName}
${result}
${errormsg}
${LAactualResult}
${testRunId}
${testjobIds}
${previous_login_id}    ${EMPTY}

*** Keywords ***
Single Session Loop
    ${session_start_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${jobIds}=   Split String     ${testjobIds}    _
    ${len}=     Get Length     ${jobIds}

    FOR   ${jobcounter}   IN RANGE     0    ${len}
        Launch OMNE Application
        ${omnecurrent_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
        ${session_running_time}      Subtract Date From Date    ${omnecurrent_datetime}    ${session_start_datetime}
#        IF    ${session_running_time} >= 5400
#            Close Application
#            Launch OMNE Application
#            ${session_start_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
#        END
        ${status}=      Set Variable    'FAIL'
        ${error}=       Set Variable    ''
        ${testjobId}=       Set Variable      ${jobIds}[${jobcounter}]
        Set Global Variable    ${testjobId}
        ${testJobStatus}=     Get TestJob Status    ${testjobId}
        Log To Console    testJobStatus: '${testJobStatus}'
        IF    "${testJobStatus}" == "SUBMITTED"
            Qrace Test Setup   ${testjobId}    1
            ${session_id}      Get Appium SessionId
            Set BrowserStack SessionUrl For TestJob    ${testjobId}    ${session_id}
            ${screenshotPath}=     Catenate    SEPARATOR=    ${screenshotDir}     /      ${testjobId}
#            Set Report Path     ${screenshotPath}
            Set Global Variable    ${screenshotPath}
            Create Directory    ${screenshotPath}
            ${status}  ${error}    Run keyword And Ignore Error     Login Application
#            IF    ${jobcounter} == 0
#                ${status}  ${error}    Run keyword And Ignore Error     Login Application
#            ELSE IF     '${Email}' != '${previous_login_id}'
#                ${status}  ${error}    Run keyword And Ignore Error     Logout From OMNE
#            ELSE
#                ${status}  ${error}    Run keyword And Ignore Error     Navigate to Home Page
#            END
            ${previous_login_id}    Set Variable    ${Email}
            ${workflow}=     Get Workflow
            ${status}  ${error}    Run keyword And Ignore Error    ${workflow}
            Set Final TestCase Status
                Log      status: '${status}'
            Log      errorMessage: '${error}'
            Qrace Test TearDown With ScreenShots   ${testjobId}    ${status}   ${error}   ${screenshotPath}
            Set Executed TestJob    ${testjobId}
            Reset Screenshot Count
            Close Application
        ELSE
            Log To Console      SKIPPING : '${testjobId}'
        END

    END
    Log To Console      END Executer TC

Main Executor
    Get Current Date and Time
    ${testtype}     Get TestType
    Set Global Variable        ${testtype}
    Log    ${testtype}
    Set Library Search Order    AppiumLibrary       SeleniumLibrary
    Set Appium Timeout    80s
    ${testCaseId}         Get TestCaseId
    Setup Actaul Result
    Insurance and Engagement Flow
    Set Calc VP With Source And Original Values    Omne_Flow    Flow_Successful    Flow_Successful    Static    Omne_Application_Flow   Flow_Successful    Flow_Successful
    Call OWB OPUS and LA IL

    Set Actual Result      ${actualResult}

Insurance and Engagement Flow
    IF    '${Flow_Flag}' == 'Insurance'
        Run Keyword    ${Insurance_Flow}
    ELSE IF    '${Flow_Flag}' == 'Engagement'
        Run Keyword    ${Engagement_Module}
    END

Call OWB OPUS and LA IL
    IF    '${OPUS_OR_OWB_App}' != ''
        Run Keyword       ${OPUS_OR_OWB_App} Executor
        Log    ${owbactualResult}
        IF    '${OPUS_OR_OWB_App}' == 'OPUS'
             ${actualResult}=    Catenate    ${actualResult}     ${opusactualResult}
             ${failstatus}    Run Keyword And Return Status    Should Contain    ${opusactualResult}      Fail Due To
        ELSE
            ${actualResult}=    Catenate    ${actualResult}     ${owbactualResult}
            ${failstatus}    Run Keyword And Return Status    Should Contain    ${owbactualResult}      Fail Due To
        END

        Set Global Variable    ${actualResult}

        IF    '${failstatus}' == 'False'
            Run Keyword   Transaction after Complete
            ${actualResult}=    Catenate    ${actualResult}  |  ${result}
            Set Global Variable    ${actualResult}
        END
    END
    #call coreSystem executor
    IF    '${CoreSystem_Flag}' == 'Yes'
        Run Keyword   ${Core_System} Executor
        IF    '${Core_System}' == 'LA'
            Log    ${LAactualResult}
            ${actualResult}=    Catenate    ${actualResult}     ${LAactualResult}
            Set Global Variable    ${actualResult}
        ELSE
             Log    ${ILactualResult}
             ${actualResult}=    Catenate    ${actualResult}  ${ILactualResult}
              Set Global Variable    ${actualResult}
        END

    END
    ${actualResult}    Catenate    ${actualResult}    |    ${result}
    Set Global Variable    ${actualResult}
Set Final TestCase Status
    ${status}   Run Keyword And Return Status    Should Contain    ${actualResult}    Failed due to
    IF    '${status}' == 'True'
         Set TestJob Status    ${testjobId}    FAILED
    ELSE
         Set TestJob Status    ${testjobId}    PASSED
    END


Setup Actaul Result
   IF    '${Policy_No}' != ''
        Set Global variable     ${actualResult}    Env : ${env} (${buildversion}_${buildid})| Device : ${deviceName} | Policy Number: ${Policy_No}
   ELSE
        Set Global variable     ${actualResult}    Env : ${env} (${buildversion}_${buildid})| Device : ${deviceName}
   END
   ${actualResult}     Catenate    ${actualResult}    |  ${LoginMethod} Successfully With User : ${Email}
   Set Global Variable    ${actualResult}

