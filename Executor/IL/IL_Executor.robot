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
    IL Login
    ${ILactualResult}    Catenate    ${ILactualResult}    IL Login Successfully
    Run Keyword    IL_${CoreSystem_Flow}
    ${ILactualResult}    Catenate   ${ILactualResult}
    ...    | IL Client Enquiry Successfully | Client Number :
    ...    ${IL_ClientNumber}
    Close Browser
    Set Global Variable    ${ILactualResult}
