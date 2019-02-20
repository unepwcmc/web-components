import { getInputs, preventTab, TAB_KEYCODE } from "../helpers/focus-helpers";

export default (toggleVariable) => ({
  data() {
    return {
      firstInput: {},
      lastInput: {},
      modalElement: {}
    }
  },

  mounted () {
    if(this[toggleVariable]) {
      this.addEventListeners()
    }
  },

  watch: {
    [toggleVariable] (isExpanded) {
      document.activeElement.blur()

      if (isExpanded) {
        this.addEventListeners()

        this.$nextTick(() => {
          this.firstInput.focus()
        })
      } else {
        this.removeEventListeners()

        if (this.mixinTriggerId) {
          document.querySelector('#' + this.mixinTriggerId).focus()
        }
      }
    }
  },

  methods: {
    addEventListeners() {
      this.modalElement = this.mixinModalId ? document.querySelector('#' + this.mixinModalId) : this.$el
      const inputs = getInputs(this.modalElement)
      this.firstInput = inputs[0]
      this.lastInput = inputs[inputs.length - 1]
  
      const isRadioGroup = this.mixinIsRadioGroup !== undefined ? this.mixinIsRadioGroup : false
  
      if (isRadioGroup) {
        this.modalElement.addEventListener('keydown', preventTab)
      } else {
        this.lastInput.addEventListener('keydown', this.handleLastInputTab)
        this.firstInput.addEventListener('keydown', this.handleFirstInputTab)
      }
    },

    removeEventListeners () {
      this.modalElement.removeEventListener('keydown', preventTab)
      this.firstInput.removeEventListener('keydown', this.handleFirstInputTab)
      this.lastInput.removeEventListener('keydown', this.handleLastInputTab)
    },

    handleFirstInputTab (e) {
      if (e.keyCode === TAB_KEYCODE && e.shiftKey) {
        e.preventDefault()
        this.lastInput.focus()
      }
    },

    handleLastInputTab (e) {
      if (e.keyCode === TAB_KEYCODE && !e.shiftKey) {
        e.preventDefault()
        this.firstInput.focus()
      }
    },
  }
})