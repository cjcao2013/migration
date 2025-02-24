*** Settings ***
Library             OperatingSystem
Library             AppiumLibrary
Library             Screenshot
Library             FakerLibrary
Library             Mainframe3270
Library             ../../Qrace/QraceHelper.py
Resource            ../../CustomLibraries/common.robot
Resource            ../../Pages/Insurance/Common/LoginPage.resource
Resource            ../../Pages/Insurance/Common/AddOTP.resource
Resource            ../../Pages/Insurance/Common/CommonMethod.resource
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
Test Setup          Get TestRun Metadata    ${testRunId}
Test Teardown       Close Application

#Test Setup          Run Keywords    Qrace Test Setup    ${testjobId}    1
#...                     AND    Launch OMNE Application
#...                     AND    Get VPs From Qrace    ${testjobId}
#Test Teardown       Run Keywords    Set Actual Result    ${actualResult}
#...                     AND    Qrace Test TearDown    ${testjobId}    ${TEST STATUS}    ${TEST MESSAGE}
#...                     AND    Close Application


*** Variables ***
${actualResult}             ${EMPTY}
${testRunId}
${testjobIds}
${testjobId}
${screenshotDir}
${previous_login_id}    ${EMPTY}
${testCaseId}               ${EMPTY}
${udid}                     ${EMPTY}
${deviceName}               ${EMPTY}
${owbactualResult}          ${EMPTY}
${VP_Transaction_Status}    ${EMPTY}
${LAactualResult}           ${EMPTY}
${PreTxnStatus}             ${EMPTY}
${Policy_No}                ${EMPTY}
${errormsg}                 ${EMPTY}


*** Test Cases ***
OMNE Executor
    Get Details from Qrace Environment
    Set Library Search Order    AppiumLibrary       SeleniumLibrary
#    Launch OMNE Application
    #   Iterate over TestJobIds inside the Testrun
    Single Session Loop
#   Iterate over TestJobIds inside the Testrun



*** Keywords ***
Main Executor1
#    IF    '${LoginMethod}' == 'SignUp' or '${Policy_No}' == ''
    IF    '${Policy_No}' == ''
        Set Global Variable    ${actualResult}    Env : ${env} (${buildversion}_${buildid}) | Device : ${deviceName}
    ELSE
        Set Global Variable    ${actualResult}    Env : ${env} (${buildversion}_${buildid}) | Device : ${deviceName} | Policy Number: ${Policy_No}
    END
    # --login application--#
    ${actualResult}    Catenate    ${actualResult}    |    ${LoginMethod} Successfully With User : ${Email}
        IF    '${LoginMethod}' == 'SignUp'
            ${sOutput}    Run Keyword And Ignore Error    Fetching Insurance Details
            IF    ${sOutput} == ('PASS', None)
                ${actualResult}    Catenate    ${actualResult}    |    FWD Insurance Data Onboarding successful
                Set TestJob Status    ${testjobId}    PASSED
            ELSE
                IF    '${errormsg}' != ''
                    Take Screenshot    Fail_Screenshot
                    ${actualResult}    Catenate    ${actualResult}    | FWD Insurance Data Onboarding Fail Due To: ${errormsg}
                    Set Calc VP With Source And Original Values
                    ...    Omne_Flow
                    ...    Flow_Successful
                    ...    Flow_Successful
                    ...    Static
                    ...    Omne_Application_Flow
                    ...    Flow_Successful
                    ...    Flow_Successful
                ELSE
                    ${reason}    Fetch Reason    ${sOutput}
                    Take Screenshot    Fail_Screenshot
                    ${actualResult}    Catenate    ${actualResult}    | FWD Insurance Data Onboarding Fail Due To: ${reason}
                    Set Calc VP With Source And Original Values
                    ...    Omne_Flow
                    ...    Flow_Successful
                    ...    Flow_Failed
                    ...    Static
                    ...    Omne_Application_Flow
                    ...    Flow_Successful
                    ...    Flow_Failed
                END
            END
        END
        IF    '${Flow_Flag}'== 'Insurance'
            ${sOutput}    Run Keyword And Ignore Error    ${Insurance_Flow}
            IF    ${sOutput} == ('PASS', None)
                ${actualResult}    Catenate    ${actualResult}    | FWD Insurance Flow of ${Insurance_Flow} Successful : ${result}
                Set Calc VP With Source And Original Values
                ...    Omne_Flow
                ...    Flow_Successful
                ...    Flow_Successful
                ...    Static
                ...    Omne_Application_Flow
                ...    Flow_Successful
                ...    Flow_Successful
                Set TestJob Status    ${testjobId}    PASSED
                # call owb executor
                Log To Console    OWB started
                IF    '${OWB_Flag}' == 'Yes'
                    ${sOutput}    Run Keyword And Ignore Error    OWB Executor
                    Log    ${owbactualResult}
                    ${actualResult}    Catenate    ${actualResult}    ${owbactualResult}
                    ${FailStatus}    Run Keyword And Return Status
                    ...    Should Contain
                    ...    ${owbactualResult}
                    ...    Fail Due To
                    IF    '${FailStatus}' == 'False' and '${Insurance_Flow}' != 'Submit'
                        ${sOutput}    Run Keyword And Ignore Error    Transaction after Complete
                        Log    ${owbactualResult}
                        IF    ${sOutput} == ('PASS', None)
                            ${actualResult}    Catenate    ${actualResult}    |    ${result}
                            Set TestJob Status    ${testjobId}    PASSED
                            # call coreSystem executor
                            IF    '${CoreSystem_Flag}' == 'Yes'
                                IF    '${Core_System}' == 'LA'
                                    ${sOutput}    Run Keyword And Ignore Error    LAExecutor.LA Executor
                                    Log    ${LAactualResult}
                                    IF    ${sOutput} == ('PASS', None)
                                        Log    ${LAactualResult}
                                        ${actualResult}    Catenate    ${actualResult}    ${LAactualResult}
                                        Set TestJob Status    ${testjobId}    PASSED
                                    END
                                ELSE
                                    ${sOutput}    Run Keyword And Ignore Error    IL Executor
                                    Log    ${ILactualResult}
                                    IF    ${sOutput} == ('PASS', None)
                                        Log    ${ILactualResult}
                                        ${actualResult}    Catenate    ${actualResult}    ${ILactualResult}
                                        Set TestJob Status    ${testjobId}    PASSED
                                    END
                                END
                            ELSE
                                Set TestJob Status    ${testjobId}    PASSED
                            END
                        ELSE
                            Take Screenshot    Fail_Screenshot
                            ${reason}    Fetch Reason    ${sOutput}
                            ${actualResult}    Catenate
                            ...    ${actualResult}
                            ...    | Transaction Status After OWB
                            ...    Failed Due To: ${reason}
                            Set Calc VP With Source And Original Values
                            ...    Omne_Flow
                            ...    Flow_Successful
                            ...    Flow_Failed
                            ...    Static
                            ...    Omne_Application_Flow
                            ...    Flow_Successful
                            ...    Flow_Failed
                        END
                    END
                ELSE IF    '${OPUS_Flag}' == 'Yes'
                    ${sOutput}    Run Keyword And Ignore Error    OPUS Executor
                    Log    ${opusactualResult}
                    ${actualResult}    Catenate    ${actualResult}    ${opusactualResult}
                    ${FailStatus}    Run Keyword And Return Status
                    ...    Should Contain
                    ...    ${opusactualResult}
                    ...    Fail Due To
                    IF    '${FailStatus}' == 'False' and '${Insurance_Flow}' != 'Submit'
                        ${sOutput}    Run Keyword And Ignore Error    Transaction after Complete
                        Log    ${owbactualResult}
                        IF    ${sOutput} == ('PASS', None)
                            ${actualResult}    Catenate    ${actualResult}    |    ${result}
                            Set TestJob Status    ${testjobId}    PASSED
                            # call coreSystem executor
                            IF    '${CoreSystem_Flag}' == 'Yes'
                                IF    '${Core_System}' == 'LA'
                                    ${sOutput}    Run Keyword And Ignore Error    LAExecutor.LA Executor
                                    Log    ${LAactualResult}
                                    IF    ${sOutput} == ('PASS', None)
                                        Log    ${LAactualResult}
                                        ${actualResult}    Catenate    ${actualResult}    ${LAactualResult}
                                        Set TestJob Status    ${testjobId}    PASSED
                                    END
                                ELSE
                                    ${sOutput}    Run Keyword And Ignore Error    IL Executor
                                    Log    ${ILactualResult}
                                    IF    ${sOutput} == ('PASS', None)
                                        Log    ${ILactualResult}
                                        ${actualResult}    Catenate    ${actualResult}    ${ILactualResult}
                                        Set TestJob Status    ${testjobId}    PASSED
                                    END
                                END
                            ELSE
                                Set TestJob Status    ${testjobId}    PASSED
                            END
                        ELSE
                            Take Screenshot    Fail_Screenshot
                            ${reason}    Fetch Reason    ${sOutput}
                            ${actualResult}    Catenate
                            ...    ${actualResult}
                            ...    | Transaction Status After OPUS
                            ...    Failed Due To: ${reason}
                            Set Calc VP With Source And Original Values
                            ...    Omne_Flow
                            ...    Flow_Successful
                            ...    Flow_Failed
                            ...    Static
                            ...    Omne_Application_Flow
                            ...    Flow_Successful
                            ...    Flow_Failed
                        END
                    END
                ELSE IF    '${CoreSystem_Flag}' == 'Yes'
                    ${actualResult}    Catenate    ${actualResult}    |    ${result}
                    Set TestJob Status    ${testjobId}    PASSED
                    # call coreSystem executor
                    IF    '${CoreSystem_Flag}' == 'Yes'
                        IF    '${Core_System}' == 'LA'
                            ${sOutput}    Run Keyword And Ignore Error    LAExecutor.LA Executor
                            Log    ${LAactualResult}
                            IF    ${sOutput} == ('PASS', None)
                                Log    ${LAactualResult}
                                ${actualResult}    Catenate    ${actualResult}    ${LAactualResult}
                                Set TestJob Status    ${testjobId}    PASSED
                            END
                        ELSE
                            ${sOutput}    Run Keyword And Ignore Error    IL Executor
                            Log    ${ILactualResult}
                            IF    ${sOutput} == ('PASS', None)
                                Log    ${ILactualResult}
                                ${actualResult}    Catenate    ${actualResult}    ${ILactualResult}
                                Set TestJob Status    ${testjobId}    PASSED
                            END
                        END
                    ELSE
                        Set TestJob Status    ${testjobId}    PASSED
                    END
                ELSE
                        Set TestJob Status    ${testjobId}    PASSED
                END
            ELSE
                IF    '${errormsg}' != ''
                    IF    '${testtype}'=='NEGATIVE'
                        Take Screenshot    Fail_Screenshot
                        ${actualResult}    Catenate
                        ...    ${actualResult}
                        ...    | FWD Insurance flow of ${Insurance_Flow} Failed due to :${errormsg}
                        Set Calc VP With Source And Original Values
                        ...    Omne_Flow
                        ...    Flow_Successful
                        ...    Flow_Successful
                        ...    Static
                        ...    Omne_Application_Flow
                        ...    Flow_Successful
                        ...    Flow_Successful
                    ELSE
                        Take Screenshot    Fail_Screenshot
                        ${actualResult}    Catenate
                        ...    ${actualResult}
                        ...    | FWD Insurance flow of ${Insurance_Flow} Failed due to :${errormsg}
                        Set Calc VP With Source And Original Values
                        ...    Omne_Flow
                        ...    Flow_Successful
                        ...    Flow_Failed
                        ...    Static
                        ...    Omne_Application_Flow
                        ...    Flow_Successful
                        ...    Flow_Failed
                    END
                ELSE
                    Take Screenshot    Fail_Screenshot
                    ${reason}    Fetch Reason    ${sOutput}
                    ${actualResult}    Catenate     ${actualResult}    | FWD Insurance flow of ${Insurance_Flow} Failed due to :${reason}
                    Set Calc VP With Source And Original Values
                    ...    Omne_Flow
                    ...    Flow_Successful
                    ...    Flow_Failed
                    ...    Static
                    ...    Omne_Application_Flow
                    ...    Flow_Successful
                    ...    Flow_Failed
                END
            END
        ELSE IF    '${Flow_Flag}'== 'Engagement'
            ${sOutput}    Run Keyword And Ignore Error   ${Engagement_Module}
            IF    ${sOutput} == ('PASS', None)
                ${actualResult}    Catenate    ${actualResult}    | FWD Engagement Quicklink Flow of ${Insurance_Flow} Successful : ${result}
                Set Calc VP With Source And Original Values
                ...    Omne_Flow
                ...    Flow_Successful
                ...    Flow_Successful
                ...    Static
                ...    Omne_Application_Flow
                ...    Flow_Successful
                ...    Flow_Successful
                Set TestJob Status    ${testjobId}    PASSED
            ELSE
                IF    '${errormsg}' != ''
                    IF    '${testtype}'=='NEGATIVE'
                        Take Screenshot    Fail_Screenshot
                        ${actualResult}    Catenate
                        ...    ${actualResult}
                        ...    | FWD Engagement_Quick flow of ${Engagement_Quick_link_Module} Failed due to :${errormsg}
                        Set Calc VP With Source And Original Values
                        ...    Omne_Flow
                        ...    Flow_Successful
                        ...    Flow_Successful
                        ...    Static
                        ...    Omne_Application_Flow
                        ...    Flow_Successful
                        ...    Flow_Successful
                    ELSE
                        Take Screenshot    Fail_Screenshot
                        ${actualResult}    Catenate
                        ...    ${actualResult}
                        ...    | FWD Engagement_Quick flow of ${Engagement_Quick_link_Module} Failed due to :${errormsg}
                        Set Calc VP With Source And Original Values
                        ...    Omne_Flow
                        ...    Flow_Successful
                        ...    Flow_Failed
                        ...    Static
                        ...    Omne_Application_Flow
                        ...    Flow_Successful
                        ...    Flow_Failed
                    END
                ELSE
                    Take Screenshot    Fail_Screenshot
                    ${reason}    Fetch Reason    ${sOutput}
                    ${actualResult}    Catenate     ${actualResult}    | FWD Engagement_Quick flow of ${Engagement_Quick_link_Module} Failed due to :${reason}
                    Set Calc VP With Source And Original Values
                    ...    Omne_Flow
                    ...    Flow_Successful
                    ...    Flow_Failed
                    ...    Static
                    ...    Omne_Application_Flow
                    ...    Flow_Successful
                    ...    Flow_Failed
                END
            END
        ELSE
                 Set Calc VP With Source And Original Values    Omne_Flow    Flow_Successful    Flow_Successful    Static    Omne_Application_Flow   Flow_Successful    Flow_Successful
                 Set TestJob Status    ${testjobId}    PASSED
        END

#    ELSE
#        IF    '${errormsg}' != ''
#            IF    '${testtype}'=='NEGATIVE'
#                Take Screenshot    Fail_Screenshot
#                ${actualResult}    Catenate    ${actualResult}    | ${LoginMethod} Fail Due To:${errormsg}
#                Set Calc VP With Source And Original Values
#                ...    Omne_Flow
#                ...    Flow_Successful
#                ...    Flow_Successful
#                ...    Static
#                ...    Omne_Application_Flow
#                ...    Flow_Successful
#                ...    Flow_Successful
#            ELSE
#                Take Screenshot    Fail_Screenshot
#                ${actualResult}    Catenate    ${actualResult}    |${LoginMethod} Fail Due To :${errormsg}
#                Set Calc VP With Source And Original Values
#                ...    Omne_Flow
#                ...    Flow_Successful
#                ...    Flow_Failed
#                ...    Static
#                ...    Omne_Application_Flow
#                ...    Flow_Successful
#                ...    Flow_Failed
#            END
#        ELSE
#            Take Screenshot    Fail_Screenshot
#            ${reason}    Fetch Reason    ${sOutput}
#            ${actualResult}    Catenate    ${actualResult}    | ${LoginMethod} Fail Due To: ${reason}
#            Set Calc VP With Source And Original Values
#            ...    Omne_Flow
#            ...    Flow_Successful
#            ...    Flow_Failed
#            ...    Static
#            ...    Omne_Application_Flow
#            ...    Flow_Successful
#            ...    Flow_Failed
#        END
#    END
#    ${status}  ${error}    Run keyword And Ignore Error     Navigate to Home Page
    Set Actual Result      ${actualResult}

