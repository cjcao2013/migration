*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US

Library    QraceHelper
Library    DateTime
Resource   ../../../CustomLibraries/common.robot
Resource   ../../Insurance/Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/ViewTransactions/PendingDetailsPageObjects.resource
Resource    ../../../PageObjects/Insurance/Common/CommonObjects.resource


*** Keywords ***
Pending Details
    [Arguments]     ${Statuslocator}
    TRY
        Wait Until Element Is Visible   ${${platformName}_${lang}_PendingReq_IssueDate}
        Take Screenshot    Transaction Pending Details Page
        ${currentIssuedate}      Get Current Date
        ${currIssuedate}         Convert Date    ${currentIssuedate}     result_format=%d %b %Y
        ${VP_PendingReq_IssueDate}              Get Text            ${${platformName}_${lang}_PendingReq_IssueDate}
        Set Calc VP With Source And Original Values    Pending Request Issue Date    ${currIssuedate}    ${VP_PendingReq_IssueDate.strip()}    Static    Transaction Pending detail Page    ${currIssuedate}    ${VP_PendingReq_IssueDate.strip()}
        IF    '${Insurance_Flow}' != 'Submit claim'
            ${VP_PendReasonElements}                Get Webelements     ${${platformName}_${lang}_PendReasonElements}
            ${VP_DocumentTypesElements}             Get Webelements     ${${platformName}_${lang}_DocumentTypesElements}
        ELSE
            @{VP_PendingReq_IssueDate}      Split String    ${VP_PendingReq_IssueDate}      :
            ${VP_PendingReq_IssueDate}      Get From List    ${VP_PendingReq_IssueDate}    1

    #       ${VP_PendReasonElements}                Get Webelements     ${${platformName}_${lang}_TotalPendDocumentClaimElements}
           ${VP_PendReasonElements}             Get Webelements     ${${platformName}_${lang}_PendDoumnetReasonClaimElements}
        END
        @{DocumentTypeList}     Split String    ${Pend_DocumentType}        ,
        ${TotalPendingDocuments}    Get Length     ${DocumentTypeList}
        &{omnedocumentnamedict}     Create Dictionary
        FOR    ${counter}    IN RANGE    0    ${TotalPendingDocuments}
            Log    ${counter}
            IF    '${Insurance_Flow}' != 'Submit claim'
                #document type
                ${documentTypeElement}      Get From List    ${VP_DocumentTypesElements}    ${counter}
                ${documentTypeName}             Get Text    ${documentTypeElement}
            END
            #pending reason
            ${pendReasonelement}        Get From List    ${VP_PendReasonElements}    ${counter}
            ${PendingReason}        Get Text    ${pendReasonelement}
            IF    '${Insurance_Flow}' != 'Submit claim'
                @{PendingReason}        Split String    ${PendingReason}    :
                ${PendingReason}        Get From List    ${PendingReason}    1
            END
            IF    '${Insurance_Flow}' != 'Submit claim'
                Set To Dictionary    ${omnedocumentnamedict}    ${documentTypeName}     ${PendingReason}
            END
            #upload document
    #        ${iOS_clickonUploadDocument}        Set Variable            xpath=(//XCUIElementTypeStaticText[@name="${documentTypeName}"]/following-sibling::XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther)[1]
            IF    '${Insurance_Flow}' != 'Submit claim'
                ${iOS_clickonUploadDocument}        Set Variable            xpath=(//XCUIElementTypeStaticText[@name="${documentTypeName}"]/following::XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther)[1]
                ${Android_clickonUploadDocument}        Set Variable        xpath=//android.widget.TextView[@text="${documentTypeName}"]/following::android.view.ViewGroup[contains(@resource-id,'add-image')][1]
            ELSE
                ${iOS_clickonUploadDocument}        Set Variable            xpath=(//XCUIElementTypeStaticText[@name="${PendingReason}"]/following::XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther)[1]
                ${Android_clickonUploadDocument}        Set Variable        xpath=//android.widget.TextView[@text="${PendingReason}"]/following::android.view.ViewGroup[contains(@resource-id,'add-image')][1]
            END
            Click Element    ${${platformName}_clickonUploadDocument}
            IF    '${platformName}' == 'iOS'
                 ${path}     Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/hospClaim.png
                Run Keyword    Upload Document BS    ${path}
            ELSE
                ${path}     Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/hospClaim.png
                Run Keyword    Upload Document BS    ${path}
            END
            Take Screenshot    Transaction Pending detail Page
        END
        IF    '${Insurance_Flow}' != 'Submit claim'
            @{omnedocumentlist}     Get Dictionary Keys    ${omnedocumentnamedict}
            ${count}     Set Variable   0
            FOR    ${element}    IN    @{omnedocumentlist}
                Log    ${element}
                ${documentpendReason}       Get From Dictionary    ${omnedocumentnamedict}    ${element}
#                Set Calc VP Actual Result With Original And Source    DocumentName_${count}     ${element}     ${element}    Transaction Pending detail Page
#                Set Calc VP Actual Result With Original And Source    ${element}_PendingReason     ${documentpendReason.strip()}     ${documentpendReason.strip()}    Transaction Pending detail Page
                ${count}    Evaluate    ${count}+1
            END
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_SubmitButton}        timeout=5s
        Click Element    ${${platformName}_${lang}_SubmitButton}
        Sleep    3s
        Take Screenshot    Transaction Page
        Wait Until Element Is Visible    ${Statuslocator}
        ${Transactionstatus}    Get Text    ${Statuslocator}
        IF    '${platformName}' == 'iOS'
            @{Transaction_Status_List}      Split String    ${Transactionstatus}    Policy no
             Log To Console    Test1
             Take Screenshot    Transaction_Page
             ${TransactionStatus_list2}      Get From List   ${Transaction_Status_List}  0
             Log To Console    Test2
             @{TransactionStatus_list2}      Split String    ${TransactionStatus_list2}
             Log To Console    Test3
             ${Count}        Get Length    ${TransactionStatus_list2}
             ${Count}=  Evaluate    ${Count} - 1
             ${VP_Transaction_Status}        Get From List    ${TransactionStatus_list2}     ${Count}
             ${Count}=  Evaluate    ${Count} - 1
             ${VP_Transaction_Status1}        Get From List    ${TransactionStatus_list2}     ${Count}
             ${VP_Transaction_Status}   Catenate    ${VP_Transaction_Status1}    ${VP_Transaction_Status}
             Log To Console    Test4
             Log    Transaction_Status=${VP_Transaction_Status}
             Log To Console    ListCount=${Count}
        ELSE
            ${VP_Transaction_Status}    Strip String    ${Transactionstatus}
        END
        Set Calc VP With Source And Original Values    TransactionStatus After Pending Details Completion    In progress       ${VP_Transaction_Status}       Static    Transaction Page   In progress    ${VP_Transaction_Status}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   Pending Details
    END