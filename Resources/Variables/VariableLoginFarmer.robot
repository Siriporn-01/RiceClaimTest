*** Variables ***
${TAB_FARMER}           //button[contains(normalize-space(.), 'เกษตรกร')]

${TXT_USERNAME}         css=input[name="username"]
${TXT_PASSWORD}         css=input[name="password"]
${BTN_LOGIN}            //button[contains(normalize-space(.), 'เข้าสู่ระบบ')]
${BTN_KASAD}            //button[contains(normalize-space(.), 'เกษตรกร')]
${BTN_LOGOUT}           //a[contains(normalize-space(.), 'ออกจากระบบ')]

${FORM_MESSAGE}         css=[data-slot="form-message"]
${DIALOG_DESCRIPTION}   css=[data-slot="dialog-description"]
${DIALOG_CLOSE_BTN}     css=[role="dialog"] button

${BTN_USER_MENU}        css=nav button:last-of-type

${SCREENSHOT_BASE_DIR}    ${OUTPUT_DIR}/Screens