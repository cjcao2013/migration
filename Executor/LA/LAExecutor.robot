*** Settings ***
Library     OperatingSystem
Library     Mainframe3270
Resource    ../../Pages/LA/LoginPage.robot
Resource    ../../CustomLibraries/common.robot
Resource    ../../Pages/LA/ClientFlow.robot
Resource    ../../Pages/LA/CreditCardMaintenance.robot
Resource    ../../Pages/LA/TaxConsent.robot
Resource    ../../Pages/LA/ContractEnquiry.robot
Resource    ../../Pages/LA/ClientFlow.robot


*** Keywords ***
LA Executor
    ${sOutput}    Run Keyword And Ignore Error    Log in to application
    IF    ${sOutput} == ('PASS', None)
        ${LAactualResult}    Catenate    ${LAactualResult}   | LA Login Successfully
        Change Wait Time    10
        Change Wait Time After Write    10
        ${sOutput}    Run Keyword And Ignore Error    ${CoreSystem_Flow}
        IF    ${sOutput} == ('PASS', None)
            IF    '${CoreSystem_Flow}' == 'Client Inquiry'
                 ${LAactualResult}    Catenate    ${LAactualResult}    | LA Client Enquiry Successfully | Client Number :  ${LA_ClientNumber}
            ELSE
                 ${LAactualResult}    Catenate    ${LAactualResult}    | LA Client Enquiry Successfully
            END
        ELSE
            ${reason}    Fetch Reason    ${sOutput}
            ${LAactualResult}    Catenate    ${LAactualResult}    | LA Client Enquiry Failed Due To: ${reason}
            Take IL Screenshot    Login_Error
            Set Calc VP With Source And Original Values
            ...    LA_Flow
            ...    Flow_Successful
            ...    Flow_Failed
            ...    Static
            ...    LA_Application_Flow
            ...    Flow_Successful
            ...    Flow_Failed
        END
    ELSE
        ${reason}    Fetch Reason    ${sOutput}
        Take IL Screenshot    Login_Error
        ${LAactualResult}    Catenate    ${LAactualResult}    | LA Login Fail Due To: ${reason}
#    Mainframe3270.Take A    LA Login_Error
        Set Calc VP With Source And Original Values
        ...    LA_Flow
        ...    Flow_Successful
        ...    Flow_Failed
        ...    Static
        ...    LA_Flow
        ...    Flow_Successful
        ...    Flow_Failed
    END
    Set Global Variable    ${LAactualResult}
    Close Connection
