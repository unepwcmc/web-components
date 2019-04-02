<template>
  <div class="tabs">
    <ul role="tablist" class="tabs__triggers ul--unstyled flex flex-nowrap">
      <li 
        v-for="child, index in children"
        role="tab"
        tabindex="0"
        :id="triggerId(child)"
        :aria-controls="child.id"
        :aria-selected="child.isActive"
        @keypress.enter.prevent="click(child)" 
        @keypress.space.prevent="click(child)" 
        @click="click(child)" 
        :class="['tab__trigger flex-no-shrink', { 'tab__trigger--active' : child.isActive }]">
        <label :for="child.id" class="tab__title hover--pointer">{{ child.title }}</label>
      </li>
    </ul>
    <div class="tab__container">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: "tabs",

  props: {
    initActiveId: String
  },

  data () {
    return {
      children: [],
      selectedId: ''
    }
  },

  mounted () {
    this.children = this.$children.filter(child => child.$options._componentTag === 'tab')
    this.initTabs()
  },

  methods: {
    click (selectedChild) {
      this.children.forEach(child => {
        child.isActive = child.id === selectedChild.id
      })

      this.selectedId = selectedChild.id
    },

    initTabs () {
      this.children.forEach((child, index) => {
        child.isActive = this.initActiveId ? 
          child.id === this.initActiveId :
          index === 0

        if (child.isActive) {
          this.selectedId = child.id
        }
      })
    },

    triggerId (child) {
      return 'tab-trigger-' + child.id
    }
  }
}
</script>