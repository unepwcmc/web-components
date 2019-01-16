<template>
  <div class="expandable-item relative" :class="{'expandable-item--active': isActive}">
    <div 
      class="expandable-item__header hover--pointer"
      @click="toggle">
      <slot name="header"></slot>
      <i class="select__drop-arrow arrow-svg"/>
    </div>
    <div v-if="isActive" class="expandable-item__container item-padding">
      <slot name="content"></slot>
    </div>
  </div>
</template>


<script>
export default {
  props: {
    title: String
  },
  data: function () {
    return {
      isActive: false
    }
  },
  methods: {
    toggle () {
      this.isActive = !this.isActive;
    }
  }
}
</script>
