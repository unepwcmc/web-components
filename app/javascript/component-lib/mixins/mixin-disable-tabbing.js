import { disableTabbing, reenableTabbing } from '../helpers/focus-helpers'

export default toggleVariable => ({
  watch: {
    [toggleVariable] () {
      this.setTabbing()
    }
  },

  mounted() {
    this.setTabbing()
  },

  methods: {
    setTabbing () {
      this[toggleVariable] ? reenableTabbing(this.$el) : disableTabbing(this.$el)
    }
  },
})
