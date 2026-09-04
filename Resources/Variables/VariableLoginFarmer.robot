*** Variables ***
${LOC_FARMER_TAB}    //button[@role="radio" and @value="farmer"]

${INPUT_USERNAME}       css=input[name="username"]
${INPUT_PASSWORD}       css=input[name="password"]
${BTN_LOGIN}    //button[@type="submit" and contains(normalize-space(.), 'เข้าสู่ระบบ')]
${BTN_KASAD}    //button[@data-slot="dropdown-menu-trigger" and contains(normalize-space(.), 'เกษตรกร')]
${BTN_LOGOUT}    //a[@data-slot="dropdown-menu-item" and @href="/logout"]

${TITLE_LOGIN_FARMER}    //p[contains(normalize-space(.), 'เข้าสู่ระบบเกษตรกร')]
${TITLE_SYSTEM}    //p[contains(normalize-space(.), 'ระบบแจ้งรายงานความเสียหายประกันภัยข้าว')]

${MSG_FORM}    css=[data-slot="form-message"]
${MSG_DIALOG}    css=[data-slot="dialog-description"]
${BUTTON_DIALOG_CLOSE}     /html[1]/body[1]/div[2]/div[1]/a[1]

${MSG_LOGIN}         /html[1]/body[1]/div[1]/div[1]/nav[1]/div[1]/div[1]/a[1]/span[2]/p[1]

${BTN_USER_MENU}        /html[1]/body[1]/div[1]/div[1]/nav[1]/div[1]/div[3]/span[2]/button[1]

${SCREENSHOT_BASE_DIR}    ${OUTPUT_DIR}/Screens