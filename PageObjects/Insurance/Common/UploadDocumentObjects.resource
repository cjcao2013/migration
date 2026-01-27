*** Variables ***
${Android_EN_Gallery_obj}                       android=new UiSelector().text("Gallery")
${Android_EN_File_Menu}                         xpath=//android.widget.ImageButton[@content-desc="Show roots"]
${Android_EN_SelectImage}                       xpath=(//android.widget.FrameLayout[@content-desc="Button"])[2]/android.widget.ImageView
${Android_EN_Done_obj}                          android=new UiSelector().text("Done")
${Android_EN_SelectImg_GalaxyM11}               xpath=(//android.widget.ImageView[@resource-id='com.google.android.documentsui:id/icon_thumb'])[1]
${Android_EN_Next_obj}                          xpath=//android.widget.TextView[@text='Next']
${Android_EN_Save_obj}                          xpath=//android.widget.TextView[@text='Save']
${Android_EN_Yes}                               xpath=//android.widget.TextView[@text='Yes']
${Android_EN_No}                                xpath=//android.widget.TextView[@text='No']
${Android_EN_Image_Icon}                        android=new UiSelector().resourceIdMatches("^.*icon_check.*$")
${Android_EN_Image_Add_Button}                  android=new UiSelector().resourceIdMatches("^.*button_add.*$")
${Android_EN_Allow_Camera}                      android=new UiSelector().text("While using the app")
${Android_EN_Allow_Photos}                      android=new UiSelector().text("Allow all")

${Android_EN_dontallow_access}                  android=new UiSelector().text("Don’t allow")
${Android_EN_while_using_app}                   android=new UiSelector().text("While using the app")
${Android_EN_allow_access}                      android=new UiSelector().text("Allow")
${Android_EN_UploadDocument_Ok_Popup}           android=new UiSelector().text("Ok")
${Android_EN_GalleryNext}                       xpath=//android.widget.TextView[@text='Gallery']//following::android.view.ViewGroup[1]
${Android_EN_obj_doneButton}                    xpath=//android.widget.TextView[@text='Done']
${Android_EN_UploadDocument_JustConfirm_Yes}    android=new UiSelector().text("Yes")

# --IOS---#
${iOS_EN_while_using_app}                       chain=**/XCUIElementTypeButton[`label == "While using the app"`]
${iOS_EN_UploadDoument_allow_Popup}             chain=**/XCUIElementTypeButton[`label == "Allow Access to All Photos"`]
${iOS_EN_allow_access}                          chain=**/XCUIElementTypeButton[`label == "Allow Full Access"`]
${iOS_EN_allow}                                 chain=**/XCUIElementTypeButton[`label == "Allow"`]
${iOS_EN_UploadDocument_Ok_Popup}               chain=**/XCUIElementTypeButton[`label == "OK"`]
${iOS_EN_UploadDocument_JustConfirm_Yes}        chain=**/XCUIElementTypeButton[`label == "Yes"`]
${iOS_EN_dontallow_access}                      chain=**/XCUIElementTypeButton[`label == "Don’t Allow"`]
${iOS_EN_allow_Option}                      chain=**/XCUIElementTypeButton[`label == "Allow"`]

${iOS_EN_Gallery_obj}                           chain=**/XCUIElementTypeOther[`label == 'Gallery'`]
${iOS_EN_obj_albums}                            chain=**/XCUIElementTypeButton[`label == 'Albums'`]
${iOS_EN_obj_favourites}                        chain=**/XCUIElementTypeOther[`label == 'Favourites'`]
${iOS_EN_obj_selectImg}                         chain=**/XCUIElementTypeImage[-1]
${iOS_EN_obj_selectclaimImg}                    chain=**/XCUIElementTypeImage[-2]
${iOS_EN_obj_addImg}                            chain=**/XCUIElementTypeButton[`label == 'Add'`]
${iOS_EN_obj_doneButton}                        chain=**/XCUIElementTypeOther[`label == 'Done'`][-1]
${iOS_EN_obj_captureImg}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Gallery'`]/XCUIElementTypeOther[-3]
${iOS_EN_obj_img}                               chain=**/XCUIElementTypeImage
${iOS_EN_obj_nextButton}                        chain=**/XCUIElementTypeOther[`label == 'Next'`]
${iOS_EN_UploadDoument_allow_Popup}             chain=**/XCUIElementTypeButton[`label == "Allow Access to All Photos"`]
${iOS_EN_allow_access}                          chain=**/XCUIElementTypeButton[`label == "Allow Full Access"`]
${iOS_EN_allow}                                 chain=**/XCUIElementTypeButton[`label == "Allow"`]
${iOS_EN_UploadDocument_Ok_Popup}               chain=**/XCUIElementTypeButton[`label == "OK"`]
${iOS_EN_UploadDocument_JustConfirm_Yes}        chain=**/XCUIElementTypeButton[`label == "Yes"`]

${iOS_EN_Obj_doneNext}                          chain=**/XCUIElementTypeOther[`label == "Next"`]
${iOS_EN_make_claim}                            chain=**/XCUIElementTypeButton[`label == "Make a claim"`]
${iOS_EN_Start_Camera}                          chain=**/XCUIElementTypeButton[`name == "Start camera"`]
${iOS_EN_obj_captureImage1}                     chain=**/XCUIElementTypeOther[`label CONTAINS 'Gallery'`]/XCUIElementTypeOther[-3]
${iOS_EN_obj_captureImageforPersonal}           chain=**/XCUIElementTypeOther[`label CONTAINS 'Gallery'`]/XCUIElementTypeOther[-2]
${iOS_EN_GalleyNext}            chain=**/XCUIElementTypeOther[`label == 'Next'`]
${iOS_EN_GalleryDone}           chain=**/XCUIElementTypeOther[`label == "Gallery Done"`]/XCUIElementTypeOther[-1]
${Android_EN_GalleyNext}            xpath=//android.widget.TextView[@text="Next"]
${Android_EN_GalleryDone}           android=new UiSelector().description("Done")
${Android_EN_obj_captureImage1}         xpath=(//android.view.ViewGroup[@content-desc="Gallery"]//following-sibling::android.view.ViewGroup[1])[2]
${Android_EN_make_claim}                        android=new UiSelector().description("Make a claim")
${Android_EN_Start_Camera}                      android=new UiSelector().description("Start camera")
${Android_EN_obj_captureImageforPersonal}           xpath=(//android.view.ViewGroup[@content-desc="Gallery"]//following-sibling::android.view.ViewGroup[1])[3]