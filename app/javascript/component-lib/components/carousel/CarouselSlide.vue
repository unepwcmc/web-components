<template>
  <li :class="['carousel-slide', 'transition']">
    <slot :slideScope="slideScope" />
  </li>
</template>

<script>
import { getInputs } from '../../helpers/focus-helpers'
import mixinResponsive from '../../mixins/mixin-responsive'

export default {
  name: 'CarouselSlide',

  mixins: [mixinResponsive],

  props: {
    slidesPerFrame: {
      default: () => [1,1,1,1],
      type: Array
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
  
  watch: {
    isActive () {
      this.setTabIndices() 
    },

    currentBreakpoint () {
      this.setSlideStyle()
    }
  },

  mounted () {
    this.setSlideStyle()
    this.inputElements = getInputs(this.$el)
    this.setTabIndices()
  },

  methods: {
    getSlidesPerFrame() {
      switch (this.currentBreakpoint) {
      case 'mobile':
        return this.slidesPerFrame[0]
      case 'tablet':
        return this.slidesPerFrame[1]
      case 'laptop':
        return this.slidesPerFrame[2]
      case 'desktop':
        return this.slidesPerFrame[3]
      }
    },

    setTabIndices() {
      const tabIndex = this.isActive ? 0 : -1

      Array.prototype.forEach.call(this.inputElements, el => {
        el.tabIndex = tabIndex
        if(tabIndex === -1) { el.blur() }
      })
    },

    setSlideStyle () {
      const style = this.$el.style

      style.marginLeft = style.marginRight = this.marginSize + 'px'
      style.width = `calc(${100/this.getSlidesPerFrame()}% - ${2*this.marginSize}px)`
    }
  }
}
</script>