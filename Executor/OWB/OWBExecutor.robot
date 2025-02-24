*** Settings ***
Library     OperatingSystem
Library     SeleniumLibrary
Resource    ../../Pages/OWB/OwbLoginPage.resource
Resource    ../../Pages/OWB/OWBInquiryPage.resource


*** Keywords ***
OWB Executor
    Set Library Search Order    SeleniumLibrary    AppiumLibrary
    ${OWB_Policy_No}    Set Variable    ${Policy_No}
    Open Browser with OWB
    ${env}    Get Environment Attribute    OWB_ENV
    ${owbactualResult}    Set Variable    | OWB_Env : ${env}
    ${sOutput}    Run Keyword And Ignore Error    OWB Login
    IF    ${sOutput} == ('PASS', None)
        ${owbactualResult}    Catenate    ${owbactualResult}    |    OWB Login Successfully
        ${sOutput}    Run Keyword And Ignore Error    OWB Inquiry
        IF    ${sOutput} == ('PASS', None)
            ${owbactualResult}    Catenate
            ...    ${owbactualResult} |  OWB Inquiry Successfully Completed
            ...    | OWB Approval Status : ${Approved_Status} | OWB Case No.: ${OWB_Case_No}
            Set Calc VP With Source And Original Values
            ...    OWB_Flow
            ...    Flow_Successful
            ...    Flow_Successful
            ...    Static
            ...    OWB_Flow
            ...    Flow_Successful
            ...    Flow_Successful
        ELSE
            ${reason}    Fetch Reason    ${sOutput}
            ${owbactualResult}    Catenate    ${owbactualResult}    |    OWB Inquiry Fail Due To: ${reason}
            Take Screenshot    OWB Inquiry_Error
            Set Calc VP With Source And Original Values
            ...    OWB_Flow
            ...    Flow_Successful
            ...    Flow_Failed
            ...    Static
            ...    OWB_Flow
            ...    Flow_Successful
            ...    Flow_Failed
        END
    ELSE
        ${reason}    Fetch Reason    ${sOutput}
        ${owbactualResult}    Catenate    ${owbactualResult}    |    Login Fail Due To: ${reason}
        Take Screenshot    Login_Error
        Set Calc VP With Source And Original Values
        ...    OWB_Flow
        ...    Flow_Successful
        ...    Flow_Failed
        ...    Static
        ...    OWB_Flow
        ...    Flow_Successful
        ...    Flow_Failed
    END
    Close Browser
    Set Global Variable    ${owbactualResult}

