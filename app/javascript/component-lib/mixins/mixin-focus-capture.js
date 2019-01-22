const INPUT_SELECTORS = 'select, input, textarea, button, a, [tabindex]:not([tabindex="-1"])'
const TAB_KEYCODE = 9

export default (toggleVariable) => ({
  data() {
    return {
      firstInput: {}
    }
  },

  mounted () {
    const modalElement = this.mixinModalId ? document.querySelector('#' + this.mixinModalId) : this.$el
    const inputs = modalElement.querySelectorAll(INPUT_SELECTORS)
    const firstInput = inputs[0]
    const lastInput = inputs[inputs.length - 1]

    this.firstInput = firstInput

    const isRadioGroup = this.mixinIsRadioGroup !== undefined ? this.mixinIsRadioGroup : false

    if (isRadioGroup) {
      modalElement.addEventListener('keydown', e => {
        if (e.keyCode === TAB_KEYCODE) {
          e.preventDefault()
        }
      })
    } else {
      lastInput.addEventListener('keydown', e => {
        if (e.keyCode === TAB_KEYCODE && !e.shiftKey) {
          e.preventDefault()
          firstInput.focus()
        }
      })
  
      firstInput.addEventListener('keydown', e => {
        if (e.keyCode === TAB_KEYCODE && e.shiftKey) {
          e.preventDefault()
          lastInput.focus()
        }
      })
    }
  },

  watch: {
    [toggleVariable] (isExpanded) {
      document.activeElement.blur()

      if (isExpanded) {
        this.$nextTick(() => {
          this.firstInput.focus()
        })
      } else if (this.mixinTriggerId) {
        document.querySelector('#' + this.mixinTriggerId).focus()
      }
    }
  }
})