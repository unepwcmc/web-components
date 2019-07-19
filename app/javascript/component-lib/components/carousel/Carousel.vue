<template>
  <aside
    class="carousel"
    :aria-labelledby="headerId"
  >
    <h1
      :id="headerId"
      :class="{'screen-reader': !showTitle}"
    >
      {{ title }}
    </h1>

    <h2 :class="{'screen-reader': !showSlideCount}">
      {{ currentSlide }} of {{ totalSlides }}
    </h2>

    <div class="carousel__slides-container">
      <ul 
        :id="slidesId"
        v-touch:swipe.right="slideToPrevious"
        v-touch:swipe.left="slideToNext"
        class="carousel__slides transition"
        aria-live="off"
        aria-atomic="true"
      >
        <template v-for="n in 3">
          <slot 
            :id="`slot-${n}`"
            :slidesScope="slidesScope" 
          />
        </template>
      </ul>

      <div
        v-if="showArrows && hasMultipleSlides"
        class="carousel__arrow-buttons"
      >
        <button 
          :aria-controls="slidesId" 
          title="Previous slide" 
          class="carousel__arrow carousel__arrow--left hover--pointer" 
          @click="slideToPrevious"
        >
          L
        </button>
        <button 
          :aria-controls="slidesId"
          title="Next slide"
          class="carousel__arrow carousel__arrow--right hover--pointer"
          @click="slideToNext"
        >
          R
        </button>
      </div>
    </div>

    <div
      v-if="hasMultipleSlides"
      class="carousel__control-bar"
    >
      <template v-if="showIndicators">
        <button
          v-for="(slide, index) in totalSlides"
          :key="`slide-${index}`"
          :title="indicatorTitle(slide)"
          :aria-controls="slidesId"
          :aria-pressed="isCurrentSlide(slide)"
          :class="['carousel__indicator hover--pointer', selectedSlideClass(slide)]"
          @click="changeSlide(slide)"
        />
      </template>

      <button 
        v-if="slideIntervalLength" 
        :title="pauseTitle" 
        class="carousel__pause hover--pointer" 
        @click="toggleSlideInterval"
      >
        <span :class="[pauseIconClass]">P</span>
      </button>
    </div>
  </aside>
</template>

<script>
import { getChangeInIndex, getNewOrder, getWidthWithMargins, modGreaterThanZero } from './carousel-helpers'

const smallTimeout = 20

export default {
  name: 'Carousel',

  props: {
    title: {
      default: 'Carousel',
      type: String
    },
    showTitle: {
      default: false,
      type: Boolean
    },
    showArrows: {
      default: true,
      type: Boolean
    },
    showCount: {
      default: false,
      type: Boolean
    },
    slideIntervalLength: {
      default: 0,
      type: Number
    },
    showIndicators: {
      default: true,
      type: Boolean
    },
    showAllIndicators: {
      default: false,
      type: Boolean
    }
  },

  data() {
    return {
      headerId: 'carousel-heading-' + this._uid,
      slidesId: 'carousel-slides-' + this._uid,
      currentSlide: 1,
      totalSlides: 0,
      childSlideComponents: this.$children,
      slideContainer: {},
      containerWidth: 0,
      slideWidth: 0,
      slidesScope: {},
      nextSlideInterval: {},
      transitioning: false,
      transitionendHandler: {},
      isPaused: Boolean(this.slideIntervalLength)
    }
  },

  computed: {
    hasMultipleSlides () {
      return this.childSlideComponents.length > 3
    },

    showSlideCount () {
      return this.showCount && this.hasMultipleSlides
    },

    pauseIconClass () {
      return this.isPaused ? 'fas fa-play': 'fas fa-pause'
    },

    pauseTitle () {
      return this.isPaused ? 'Resume carousel' : 'Pause carousel'
    },

    showIndicatorsComputed () {
      return this.showAllIndicators || (this.showIndicators && this.totalSlides < 7)
    }
  },

  created() {
    window.addEventListener('resize', () => {
      this.setSlideWidth()
      this.initSlideContainerPosition()
    })
  },

  mounted () {
    this.initData()
    this.initSlideOrders()
    this.setSlideWidth()
    this.initSlideContainerPosition()
    this.setActiveStateOnChildren()
    this.setSlideIntervalIfConfigured()
  },

  methods: {
    selectedSlideClass (slide) {
      return {'carousel__indicator--selected' : this.isCurrentSlide(slide)}
    },

    isCurrentSlide (slide) {
      return slide === this.currentSlide
    },

    isCurrentSlideElement (slideElement) {
      return slideElement.style.order == this.totalSlides
    },

    indicatorTitle (slide) {
      return 'Move to slide ' + slide
    },

    initData () {
      this.totalSlides = this.childSlideComponents.length / 3
      this.slideContainer = this.$el.querySelector('#' + this.slidesId)
    },

    initSlideOrders () {
      Array.prototype.forEach.call(this.childSlideComponents, (child, index) => {
        child.$el.style.order = index
      })
    },

    setSlideWidth () {
      this.slideWidth = getWidthWithMargins(this.childSlideComponents[0].$el)
    },

    initSlideContainerPosition () {
      this.slideContainer.style.left = - this.totalSlides * this.slideWidth + 'px'
    },

    resetSlideIntervalIfNotPaused () {
      if (!this.isPaused) {
        this.clearSlideInterval()
        this.setSlideIntervalIfConfigured()
      }
    },

    toggleSlideInterval() {
      this.isPaused ? this.setSlideIntervalIfConfigured() : this.clearSlideInterval()
    },

    setSlideIntervalIfConfigured () {
      if (this.slideIntervalLength) { this.setSlideInterval() }
    },

    setSlideInterval () {
      this.nextSlideInterval = setInterval(() => {
        this.slideToNext(false)
      }, this.slideIntervalLength)

      this.isPaused = false
    },

    clearSlideInterval () {
      clearInterval(this.nextSlideInterval)
      this.isPaused = true
    },

    slideToNext (resetNextSlideInterval=true) {
      this.changeSlide(modGreaterThanZero(this.currentSlide + 1, this.totalSlides), resetNextSlideInterval, 1)
    },

    slideToPrevious (resetNextSlideInterval=true) {
      this.changeSlide(modGreaterThanZero(this.currentSlide - 1, this.totalSlides), resetNextSlideInterval, -1)
    },

    changeSlide (slide, resetNextSlideInterval=true, forceDirection=0) {
      if (this.transitioning || slide === this.currentSlide) { return }
      
      if (resetNextSlideInterval) { this.resetSlideIntervalIfNotPaused() }

      this.slideBy(getChangeInIndex(slide, this.currentSlide, this.totalSlides, forceDirection))
      this.currentSlide = slide
    },

    slideBy (changeInIndex) {
      this.transitioning = true
      this.moveSlideContainer(changeInIndex)
      this.replaceTransitionendHandler(changeInIndex)
    },

    moveSlideContainer (changeInIndex) {
      this.slideContainer.style.transform = `translateX(${- changeInIndex * this.slideWidth}px)`
    },
    
    replaceTransitionendHandler (changeInIndex) {
      this.slideContainer.removeEventListener('transitionend', this.transitionendHandler)
      this.transitionendHandler = this.getOnTransitionEndHandler(changeInIndex)
      this.slideContainer.addEventListener('transitionend', this.transitionendHandler)
    },

    getOnTransitionEndHandler (changeInIndex) {
      return () => {
        this.invisiblyRepositionSlides(changeInIndex)
        this.setActiveStateOnChildren()
  
        setTimeout(() => { this.transitioning = false }, smallTimeout)
      }
    },

    invisiblyRepositionSlides(changeInIndex) {        
      this.reorderSlides(changeInIndex)
      this.resetSlideContainerPosition()
    },

    resetSlideContainerPosition () {
      this.brieflyRemoveTransition(this.slideContainer)
      this.slideContainer.style.transform = 'none'
    },

    brieflyRemoveTransition (el) {
      el.classList.remove('transition')

      setTimeout(() => {
        el.classList.add('transition')
      }, smallTimeout)
    },

    reorderSlides (changeInIndex) {
      this.childSlideComponents.forEach(child => {
        child.$el.style.order = getNewOrder(child.$el.style.order, changeInIndex, this.totalSlides)
      })
    },

    setActiveStateOnChildren () {
      Array.prototype.forEach.call(this.childSlideComponents, child => {
        child.isActive = this.isCurrentSlideElement(child.$el)
      })
    }
  }
}
</script>