*** Variables ***
#Pending request objects
#**/XCUIElementTypeOther[`label CONTAINS 'Nov 14 2023' and label CONTAINS 'Nominate settlement account' and label CONTAINS 'Policy no: 42212953'`][25]/XCUIElementTypeOther[2]--pending detail button
${iOS_EN_PendingReq_IssueDate}              chain=**/XCUIElementTypeOther[`label CONTAINS 'Pending requirement issued on'`]/XCUIElementTypeStaticText[2]
${iOS_EN_PendReasonElements}                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Pending reason:"`]
${iOS_EN_DocumentTypesElements}              xpath=//XCUIElementTypeStaticText[contains(@name,'Pending reason')]/preceding::XCUIElementTypeStaticText[1]
${iOS_EN_UploadPendDocumentElements}                    chain=**/XCUIElementTypeOther[`name == "add-image"`]
${iOS_EN_TotalPendDocumentClaimElements}            chain=**/XCUIElementTypeStaticText[`label CONTAINS "Pending requirement"`]
${iOS_EN_PendDoumnetReasonClaimElements}            xpath=//XCUIElementTypeStaticText[contains(@name,'Pending requirement')]/preceding::XCUIElementTypeStaticText[1]

${Android_EN_PendingReq_IssueDate}      xpath=//android.widget.TextView[@text='Pending requirement issued on']/following-sibling::android.widget.TextView
${Android_EN_PendReasonElements}        xpath=//android.widget.TextView[contains(@text,'Pending reason')]
${Android_EN_DocumentTypesElements}      xpath=//android.view.ViewGroup[contains(@resource-id,'add-image')]/preceding::android.widget.TextView[2]

