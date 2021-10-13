<template>
  <li :class="['carousel-slide', 'transition']">
    <slot :slideScope="slideScope" />
  </li>
</template>

<script>
import { getInputs } from '../../helpers/focus-helpers'

export default {
  name: 'CarouselSlide',


  data () {
    return {
      slideScope: {},
      isActive: false,
      inputElements: []
    }
  },
  
  watch: {
    isActive () {
      this.setTabIndices() 
    }
  },

  mounted () {
    this.inputElements = getInputs(this.$el)
    this.setTabIndices()
  },

  methods: {
    setTabIndices() {
      const tabIndex = this.isActive ? 0 : -1

      Array.prototype.forEach.call(this.inputElements, el => {
        el.tabIndex = tabIndex
        if(tabIndex === -1) { el.blur() }
      })
    }
  }
}
</script>