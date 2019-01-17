<template>
  <div class="expandable-item relative" :class="{'expandable-item--active': isActive}">
    <div 
      class="expandable-item__header hover--pointer flex flex-v-center"
      @click="toggle">
      <slot name="header"></slot>
      <span class="drop-arrow drop-arrow--end arrow-svg"></span>
    </div>
    <div v-if="isActive" class="expandable-item__container item-padding">
      <slot name="content"></slot>
    </div>
  </div>
</template>


<script>
import mixinPopupCloseListeners from './mixins/mixin-popup-close-listeners'

export default {
  mixins: [mixinPopupCloseListeners('close')],
  props: {
    title: String
  },
  data () {
    return {
      isActive: false
    }
  },
  methods: {
    toggle () {
      this.isActive ? this.close() : this.open()
    },
    close () {
      this.isActive = false
    },
    open () {
      this.isActive = true
    }
  }
}
</script>