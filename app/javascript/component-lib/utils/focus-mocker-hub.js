export default {
  data() {
    return {
      lastActiveElement: {}
    }
  },

  created () {
    this.lastActiveElement = document.activeElement

    window.addEventListener ? window.addEventListener('focus', this.detectFocus, true) : window.attachEvent('onfocusout', this.detectFocus)
    window.addEventListener ? window.addEventListener('blur', this.detectBlur, true) : window.attachEvent('onblur', this.detectBlur)
  },

  methods: {
    detectBlur () {
      if(this.lastActiveElement && this.lastActiveElement.getAttribute('data-mock-focus-id')) {
        this.$emit('remove-mock-focus', this.lastActiveElement.getAttribute('data-mock-focus-id'))
      }
      this.lastActiveElement = document.activeElement
    },
    
    detectFocus() {
      if(document.activeElement.getAttribute('data-mock-focus-id')) {
        this.$emit('add-mock-focus', document.activeElement.getAttribute('data-mock-focus-id'))
      }
      this.lastActiveElement = document.activeElement
    }
  }
}