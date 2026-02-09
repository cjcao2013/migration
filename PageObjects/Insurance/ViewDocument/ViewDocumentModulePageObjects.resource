*** Variables ***
${iOS_EN_Document_Download_Button}                  chain=**/XCUIElementTypeOther[`label == "Preview document"`]/XCUIElementTypeOther
${iOS_EN_Document_Show_all}                         chain=**/XCUIElementTypeOther[`name == "Show all"`]
${Android_EN_Document_Show_all}                     android=new UiSelector().text("Show all")
${Android_EN_Document_Popup_Download_Button}        xpath=//android.widget.TextView[@text='Download']
${iOS_EN_Document_Popup_Download_Button}            chain=**/XCUIElementTypeOther[`label == "Download"`]

${Android_EN_Document_Download_Document_Name}       xpath=//android.widget.TextView[contains(@text, '.pdf')]

${Android_EN_Document_Print_Button}                 xpath=//android.widget.TextView[@text='Print']
${Android_EN_Document_Dropdown_List}                xpath=//android.widget.Spinner[@resource-id='com.android.printspooler:id/destination_spinner']
${Android_EN_Document_SaveAsPDF_txt}                xpath=//android.widget.TextView[@text='Save as PDF']
${Android_EN_Document_Save_To_PDF}                  accessibility_id=Save to PDF
${Android_EN_Document_PDF_Name_TextBox}             xpath=//android.widget.EditText[@resource-id='android:id/title']
${Android_EN_Document_SAVE_Button}                  xpath=//android.widget.Button[@text='SAVE']
${Android_EN_Document_Preview_Document}             xpath=//android.widget.TextView[@text='Preview document']
${Android_EN_Document_Download_Button}              xpath=//android.widget.TextView[@text='Preview document']/following-sibling::android.view.ViewGroup[1]/android.view.ViewGroup


${iOS_EN_Document_Download_SaveFiles}               accessibility_id=Save to Files
${iOS_EN_Document_Download_BackBtn}                 chain=**/XCUIElementTypeButton[`label == "Browse"`]
${iOS_EN_Document_Download_Folder}                  chain=**/XCUIElementTypeImage[`label == "Forward"`][7]
${iOS_EN_Download_SaveBtn}                          chain=**/XCUIElementTypeButton[`label == "Save"`]
${iOS_EN_OnMyIPhoneFolderTxt}               chain=**/XCUIElementTypeStaticText[`label == "On My iPhone"`]
${iOS_EN_DowloadFolder}                     chain=**/XCUIElementTypeCell[`label == "Downloads, 0 items"`]/XCUIElementTypeOther[2]/XCUIElementTypeOther[1]/XCUIElementTypeImage
${iOS_EN_DocumentName}                      chain=**/XCUIElementTypeTextField[-1]
${iOS_EN_Document_SaveButton}               chain=**/XCUIElementTypeButton[`label == "Save"`]
${iOS_EN_SaveNotificationPopUp}             chain=**/XCUIElementTypeButton[`label == "Replace"`]


${Android_EN_previewDocument_backBtn}               xpath=//android.widget.TextView[@text='Preview document']/preceding::android.view.ViewGroup[1]
${iOS_EN_previewDocument_backBtn}                   chain=**/XCUIElementTypeOther[`label CONTAINS "Preview document"`][-2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]
