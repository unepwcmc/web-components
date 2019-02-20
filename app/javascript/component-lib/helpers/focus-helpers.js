const INPUT_SELECTORS = 'select, input, textarea, button, a, [tabindex]:not([tabindex="-1"])'
const DISABLED_TAB_VALUE = -5;
export const TAB_KEYCODE = 9;

export const getInputs = el => el.querySelectorAll(INPUT_SELECTORS)

export const preventTab = e => {
  if (e.keyCode === TAB_KEYCODE) {
    e.preventDefault()
  }
}

export const disableTabbing = el => {
  getInputs(el).forEach(input => {
    input.tabIndex = DISABLED_TAB_VALUE
  })
}

export const reenableTabbing = el => {
  el.querySelectorAll(`[tabindex='${DISABLED_TAB_VALUE}']`).forEach(input => {
    input.tabIndex = 0
  })
}