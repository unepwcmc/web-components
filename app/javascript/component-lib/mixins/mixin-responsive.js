import { eventHub } from '../../vue'

export default {
  data () {
    return {
      windowWidth: 0,
      currentBreakpoint: '',
      breakpoints: {
        small: 720,
        medium: 1024,
        large: 1680
      }
    }
  },

  created () {
    this.updateWindowSize()

    // allow for multiple functions to be called on window resize
    window.addEventListener('resize', () => eventHub.$emit('windowResized'))

    eventHub.$on('windowResized', this.updateWindowSize)
  },

  methods: {
    updateWindowSize () {
      this.windowWidth = window.innerWidth

      if(this.isMobile()) { this.currentBreakpoint = 'mobile' }
      if(this.isTablet()) { this.currentBreakpoint = 'tablet' }
      if(this.isLaptop()) { this.currentBreakpoint = 'laptop' }
      if(this.isDesktop()) { this.currentBreakpoint = 'desktop' }
    },

    isMobile () {
      return this.windowWidth <= this.breakpoints.small
    },

    isTablet () {
      return this.windowWidth > this.breakpoints.small && this.windowWidth <= this.breakpoints.medium
    },

    isLaptop () {
      return this.windowWidth > this.breakpoints.medium && this.windowWidth <= this.breakpoints.large
    },

    isDesktop () {
      return this.windowWidth > this.breakpoints.large
    },

    getCurrentBreakpoint () {
      return this.currentBreakpoint
    }
  }
}
