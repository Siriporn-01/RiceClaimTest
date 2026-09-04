*** Variables ***
${TITLE_LOGIN_STAFF}    //p[contains(normalize-space(.), 'เข้าสู่ระบบเจ้าหน้าที่')]

${LOC_STAFF_TAB}    //button[@role="radio" and @value="officer"]

${COMBOBOX_OFFICER_TYPE}    css=button[role="combobox"][data-slot="form-control"]
${OPT_AGRICULTURE_OFFICER}         //div[@role="option" and contains(normalize-space(.), 'เจ้าหน้าที่เกษตรกร')]
