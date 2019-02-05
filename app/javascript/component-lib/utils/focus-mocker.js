let lastActiveElement = document.activeElement

const getMockFocusedElement = element => document.querySelector('#' + element.getAttribute('data-mock-focus-id'))

const detectBlur = () => {
  if(lastActiveElement.getAttribute('data-mock-focus-id')) {
    getMockFocusedElement(lastActiveElement).classList.remove('focussed')
  }
  lastActiveElement = document.activeElement
}

const detectFocus = () => {
  if(document.activeElement.getAttribute('data-mock-focus-id')) {
    getMockFocusedElement(document.activeElement).classList.add('focussed')
  }
  lastActiveElement = document.activeElement
}

export default () => {
    window.addEventListener ? window.addEventListener('focus', detectFocus, true) : window.attachEvent('onfocusout', detectFocus)

    window.addEventListener ? window.addEventListener('blur', detectBlur, true) : window.attachEvent('onblur', detectBlur)
}