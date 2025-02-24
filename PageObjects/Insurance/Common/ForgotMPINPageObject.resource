*** Variables ***
${iOS_EN_IncorrectPIN_Error}      chain=**/XCUIElementTypeStaticText[`name == "Incorrect PIN. You can try 4 more times."`]
${iOS_EN_Forgot_PIN}      chain=**/XCUIElementTypeOther[`name == "Forgot PIN?"`]
${iOS_EN_SetNewPIN}        chain=**/XCUIElementTypeStaticText[`name == "Set a new PIN"`]