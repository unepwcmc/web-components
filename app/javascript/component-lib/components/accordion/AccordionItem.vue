<template>
  <div class="accordion-item">
    <button
      :id="toggleId"
      :aria-haspopup="true"
      :aria-controls="contentId"
      :aria-expanded="isActive"
      class="accordion-item__toggle hover--pointer flex flex-h-between"
      @click="toggleAccordionContent()"
    >
      <label
        :for="toggleId"
        class="accordion-item__title"
      >{{ title }}</label>
      <span class="accordion-item__toggle-icon">{{ arrow }}</span>
    </button>
    
    <transition name="accordion-toggle">
      <div
        v-show="isActive"
        :id="contentId"
        role="region"
        class="accordion-item__content-wrapper"
      >
        <div class="accordion-item__content">
          <slot />
        </div>
      </div>
    </transition>
  </div>  
</template>

<script>
import { eventHub } from '../../../vue.js'

export default {
  name: 'AccordionItem',

  props: {
    id: {
      required: true,
      type: String
    },
    title: {
      type: String,
      default: '',
    },
    open: {
      type: Boolean,
      default: false
    } 
  },

  data () {
    return {
      isActive: this.open,
      toggleId: 'accordion-toggle-' + this.id,
      contentId: 'accordion-content-' + this.id
    }
  },

  computed: {
    arrow () {
      return this.isActive ? '-' : '+'
    }
  },

  methods: {
    toggleAccordionContent () {
      eventHub.$emit('call-toggle-accordion-content', this.id)
    }
  }
}
</script>