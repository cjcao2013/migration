*** Settings ***
Resource    ../../CustomLibraries/common.robot
Resource    ../../Pages/IL/Login.robot
Resource    ../../Pages/IL/ClientEnquiry.robot
Resource    ../../Pages/IL/ProposalsandContracts.robot
Library     QraceHelper


*** Variables ***
${ILactualResult}       ${EMPTY}


*** Keywords ***
IL Executor
    Set Library Search Order    SeleniumLibrary    AppiumLibrary
    ${IL_url}    Get Environment Attribute    IL_URL
    Open IL Chrome Browser    ${IL_url}
    ${sOutput}    Run Keyword And Ignore Error    IL Login
    IF    ${sOutput} == ('PASS', None)
        ${ILactualResult}    Catenate    ${ILactualResult}    IL Login Successfully
        ${sOutput}    Run Keyword And Ignore Error    IL_${CoreSystem_Flow}
        IF    ${sOutput} == ('PASS', None)
            ${ILactualResult}    Catenate
            ...    ${ILactualResult}
            ...    | IL Client Enquiry Successfully | Client Number :
            ...    ${IL_ClientNumber}
        ELSE
            ${reason}    Fetch Reason    ${sOutput}
            ${ILactualResult}    Catenate    ${ILactualResult}    | Client Enquiry Failed Due To: ${reason}
            Take IL Screenshot    Login_Error
            Set Calc VP With Source And Original Values
            ...    IL_Flow
            ...    Flow_Successful
            ...    Flow_Failed
            ...    Static
            ...    IL_Application_Flow
            ...    Flow_Successful
            ...    Flow_Failed
        END
    ELSE
        ${reason}    Fetch Reason    ${sOutput}
        ${ILactualResult}    Catenate    ${ILactualResult}    | IL Login Failed Due To: ${reason}
        Take IL Screenshot    Login_Error
        Set Calc VP With Source And Original Values
        ...    IL_Flow
        ...    Flow_Successful
        ...    Flow_Failed
        ...    Static
        ...    IL_Application_Flow
        ...    Flow_Successful
        ...    Flow_Failed
    END
    Close Browser
    Set Global Variable    ${ILactualResult}
