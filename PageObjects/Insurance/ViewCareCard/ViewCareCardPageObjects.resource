*** Variables ***
${Android_EN_viewcardDocument_Download_Button}              xpath=//android.widget.TextView[@text='Preview document']/following-sibling::android.view.ViewGroup[1]/android.view.ViewGroup
${iOS_EN_viewcardDocument_Download_Button}                  chain=**/XCUIElementTypeOther[`name == "Preview care card"`]/XCUIElementTypeOther

${Android_EN_Document_Popup_Download_Button}        xpath=//android.widget.TextView[@text='Download']
${iOS_EN_Document_Popup_Download_Button}            chain=**/XCUIElementTypeOther[`label == "Download"`]

${Android_EN_Document_Download_Document_Name}       xpath=//android.widget.TextView[contains(@text, '.pdf')]

${iOS_EN_Document_Download_SaveFiles}               chain=**/XCUIElementTypeStaticText[`label == "Save to Files"`]
${iOS_EN_Document_Download_BackBtn}                 chain=**/XCUIElementTypeButton[`label == "Browse"`]
${iOS_EN_Document_Download_Folder}                  chain=**/XCUIElementTypeImage[`label == "Forward"`][7]
${iOS_EN_Download_SaveBtn}                          chain=**/XCUIElementTypeButton[`label == "Save"`]
${iOS_EN_DocumentName}                      chain=**/XCUIElementTypeTextField[-1]
${iOS_EN_Document_SaveButton}               chain=**/XCUIElementTypeButton[`label == "Save"`]
${iOS_EN_SaveNotificationPopUp}             chain=**/XCUIElementTypeButton[`label == "Replace"`]
${Android_EN_carecardpreviewDocument_backBtn}               xpath=//android.widget.TextView[@text='Preview document']/preceding::android.view.ViewGroup[1]
${iOS_EN_carecardpreviewDocument_backBtn}                   chain=**/XCUIElementTypeOther[`name CONTAINS "Preview care card Vertical scroll bar"`][-1]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther

${iOS_EN_MyPolicy_SellAll_Tab}      chain=**/XCUIElementTypeOther[`label == "My policy(s) See all"`]/XCUIElementTypeOther[-1]
${Android_EN_MyPolicy_SellAll_Tab}        xpath=//android.widget.TextView[@text="My policy(s)"]//following-sibling::android.view.ViewGroup[@content-desc="See all"]

${iOS_EN_MyPolicyCareCardOption}        accessibility_id=View care card
${Android_EN_MyPolicyCareCardOption}