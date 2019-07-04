<template>
  <div class="accordion">
    <slot />
  </div>
</template>

<script>
import { eventHub } from '../../../vue.js'

export default {
  name: 'Accordion',

  data () {
    return {
      children: this.$children
    }
  },

  mounted () {
    eventHub.$on('call-toggle-accordion-content', this.toggleAccordionContent)
  },

  methods: {
    toggleAccordionContent (id) {
      this.children.forEach(child => {
        child.isActive = child.id === id && child.isActive !== true
      })
    }
  }
}
</script>
