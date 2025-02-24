*** Settings ***
Library     OperatingSystem
Library     SeleniumLibrary
Resource    ../../Pages/OPUS/OPUSLoginPage.resource
Resource    ../../Pages/OPUS/OPUSInquiryPage.resource
Resource     ../../Pages/OPUS/OPUSTaskInquiryPage.resource
Library     ../../Qrace/QraceHelper.py
Resource    ../../CustomLibraries/common.robot

*** Variables ***
${opusactualResult}

*** Keywords ***
OPUS Executor
    Set Library Search Order    SeleniumLibrary    AppiumLibrary
    TRY
        ${OPUS_Policy_No}    Set Variable    ${Policy_No}
        Open Browser with OPUS
        Set OPUS Actual Result
        OPUS Login
        OPUS Inquiry
        Set Calc VP With Source And Original Values    OWB_Flow    Flow_Successful    Flow_Successful    Static    OWB_Flow   Flow_Successful    Flow_Successful
        Close Browser
        Set Global Variable    ${owbactualResult}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Flow  ${Insurance_Flow}
    END

Set OPUS Actual Result
    ${env}          Get Environment Attribute    OWB_ENV
    ${opusactualResult}=     Set Variable    | OPUS_Env : ${env}
    Set Global Variable    ${opusactualResult}



    # [Return]    ${owbactualResult}
