const ESCAPE_KEYCODE = 27

export default (closeCallback, isActive='isActive', closeOnClickOutside=true, closeOnEscKeypress=true) => ({
  mounted () {
    if(closeOnClickOutside) {
      window.addEventListener('click', e => {
        if (!this.$el.contains(e.target)) { this[closeCallback]() }
      })
    }

    if(closeOnEscKeypress) {
      this.$el.addEventListener('keydown', e => {
  
        if (e.keyCode === ESCAPE_KEYCODE) { 
          if(this[isActive]) {
            this[closeCallback]()
            e.stopPropagation()
          }
        }
      })
    }
  },
})