<template>
  <div class="expandable-item relative" :class="{'expandable-item--active': isActive}">
    <button
      aria-haspopup="true"
      :aria-expanded="isActive"
      :aria-controls="contentId"
      class="expandable-item__header hover--pointer flex flex-v-center"
      @click="toggle">
      <slot name="header"></slot>
      <span class="drop-arrow drop-arrow--end arrow-svg"></span>
    </button>
    <div v-if="isActive" :id="contentId" class="expandable-item__container item-padding">
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
      isActive: false,
      contentId: `expandable-item-content-${this._uid}`
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