const ESCAPE_KEYCODE = 27

export default ({closeCallback, toggleVariable='isActive', closeOnClickOutside=true, closeOnEscKeypress=true}) => ({
  mounted () {
    if(closeOnClickOutside) {
      window.addEventListener('click', e => {
        if (this[toggleVariable] && !this.$el.contains(e.target)) { this[closeCallback](e) }
      })
    }

    if(closeOnEscKeypress) {
      this.$el.addEventListener('keydown', e => {
  
        if (e.keyCode === ESCAPE_KEYCODE) { 
          if(this[toggleVariable]) {
            this[closeCallback](e)
            e.stopPropagation()
          }
        }
      })
    }
  },
})