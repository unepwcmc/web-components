<template>
  <li :class="['carousel-slide', 'transition']">
    <slot :slideScope="slideScope"></slot>
  </li>
</template>

<script>
import { getInputs } from '../../helpers/focus-helpers';

export default {
  name: 'carousel-slide',

  props: {
    slidesPerFrame: {
      default: 1,
      type: Number
    },
    marginSize: {
      default: 10,
      type: Number
    }
  },

  data () {
    return {
      slideScope: {},
      isActive: false,
      inputElements: []
    }
  },

  mounted () {
    this.setSlideStyle()
    this.inputElements = getInputs(this.$el)
    this.setTabIndices()
  },

  watch: {
    isActive () {
      this.setTabIndices() 
    }
  },

  methods: {
    setTabIndices() {
      const tabIndex = this.isActive ? 0 : -1

      this.inputElements.forEach(el => {
        el.tabIndex = tabIndex
        if(tabIndex === -1) { el.blur() }
      })
    },

    setSlideStyle () {
      const style = this.$el.style

      style.marginLeft = style.marginRight = this.marginSize + 'px'
      style.width = `calc(${100/this.slidesPerFrame}% - ${2*this.marginSize}px)`
    }
  }
}
</script>