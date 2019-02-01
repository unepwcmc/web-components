<template>
  <aside class="carousel" aria-labelledby="carousel-heading">

    <h1 id="carousel-heading" :class="{'screen-reader': !showTitle}">{{ title }}</h1>

    <h2 :class="{'screen-reader': !showSlideCount}">{{ currentSlide }} of {{ totalSlides }}</h2>

    <div class="carousel__slides-container">

      <ul id="carousel-slides" class="carousel__slides transition" aria-live="off" aria-atomic="true">
        <template v-for="n in 3">
          <slot :slidesScope="slidesScope"></slot>
        </template>
      </ul>

      <div v-if="showArrows && hasMutlipleSlides" class="carousel__arrow-buttons">
        <button aria-controls="carousel-slides" title="Previous slide" class="carousel__arrow carousel__arrow--left" @click="slideToPrevious()">
          L
        </button>
        <button aria-controls="carousel-slides" title="Next slide" class="carousel__arrow carousel__arrow--right" @click="slideToNext()">
          R
        </button>
      </div>

    </div>

    <div v-if="hasMutlipleSlides" class="carousel__control-bar">
      <template v-if="showIndicators">
        <button
          v-for="slide in totalSlides"
          :title="indicatorTitle(slide)"
          aria-controls="carousel-slides"
          :aria-pressed="isCurrentSlide(slide)"
          :class="['carousel__indicator', selectedSlideClass(slide)]"
          @click="changeSlide(slide)"></button>
      </template>

      <button :title="pauseTitle" v-if="this.slideIntervalLength" class="carousel__pause" @click="toggleSlideInterval">
        <span :class="[pauseIconClass]">P</span>
      </button>
    </div>

  </aside>
</template>

<script>
import { getChangeInIndex, getNewOrder, getWidthWithMargins, modGreaterThanZero } from './carousel-helpers'

const smallTimeout = 20

module.exports = {
  name: 'carousel',

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
    showAllIndicators: {
      default: false,
      type: Boolean
    }
  },

  data() {
    return {
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

  created() {
    window.onresize = () => {
      this.setSlideWidth()
      this.initSlideContainerPosition()
    }
  },

  mounted () {
    this.initData()
    this.initSlideOrders()
    this.setSlideWidth()
    this.initSlideContainerPosition()
    this.setActiveStateOnChildren()
    this.setSlideIntervalIfConfigured()
  },

  computed: {
    hasMutlipleSlides () {
      return this.childSlideComponents.length > 3
    },

    showSlideCount () {
      return this.showCount && this.hasMutlipleSlides
    },

    pauseIconClass () {
      return this.isPaused ? 'fas fa-play': 'fas fa-pause'
    },

    pauseTitle () {
      return this.isPaused ? 'Resume carousel' : 'Pause carousel'
    },

    showIndicators () {
      return this.showAllIndicators || this.totalSlides < 7
    }
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
      this.slideContainer = this.$el.querySelector('#carousel-slides')
    },

    initSlideOrders () {
      this.childSlideComponents.forEach( (child, index) => {
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
      this.childSlideComponents.forEach(child => {
        child.isActive = this.isCurrentSlideElement(child.$el)
      })
    }
  }
}
</script>

<style lang="scss">
$grey: grey;
$padding-top-bottom: 25px;
$padding-side: 40px;

$indicator-height: 14px;
$indicator-row-height: $indicator-height + $padding-top-bottom * 2;
$transition-options: 0.6s ease-in-out;

.transition {
  &.carousel__slides {
    transition: transform $transition-options;
  }
}

.carousel {
  padding-top: $padding-top-bottom;

  position: relative;

  &__slides-container {
    width: 100%; height: calc(100% - #{$indicator-row-height});
    overflow: hidden;
  }

    &__slides {
      height: 100%;
      
      position: relative;
      display: flex;
    }

    &__arrow-buttons {
      pointer-events: none;
      width: 100%;
      
      display: flex;
      justify-content: space-between;
      position: absolute;
      top: 50%;

      transform: translateY(-50%);
    }

      &__arrow {
        background-color: rgba($grey, 0.4);
        padding: 18px 8px;
        pointer-events: auto;
      }

  &__control-bar {    
    color: grey;
    padding: 0 $padding-side;
    height: $indicator-row-height;

    display: flex;
    align-items: center;
  }

    &__pause {
      background-color: rgba($grey, 0.4);
      border-radius: 50%;
      width: 2em; height: 2em;

      justify-self: flex-end;
      margin-left: auto;
    }

    &__indicator {
      background-color: rgba($grey, 0.4);
      border-radius: 50%;
      margin-right: $indicator-height / 3;
      width: $indicator-height; height: $indicator-height;

      display: inline-block;

      transition: background-color $transition-options;

      &--selected {
        background-color: $grey;
      }
    }
}

.carousel-slide {
  flex-shrink: 0;
}
</style>
