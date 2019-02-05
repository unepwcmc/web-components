export default (closeCallback, closeOnClickOutside=true, closeOnEscKeypress=true) => ({
  mounted () {
    if(closeOnClickOutside) {
      window.addEventListener('click', e => {
        if (!this.$el.contains(e.target)) { this[closeCallback]() }
      })
    }

    if(closeOnEscKeypress) {
      this.$el.addEventListener('keydown', e => {
        const ESCAPE_KEYCODE = 27
  
        if (this.isActive && e.keyCode === ESCAPE_KEYCODE) { 
          this[closeCallback]()
          e.stopPropagation()
        }
      })
    }
  },
})