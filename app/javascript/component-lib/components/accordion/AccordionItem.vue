<template>
  <div class="accordion-item">
    <button
      :id="toggleId"
      :aria-haspopup="true"
      :aria-controls="contentId"
      :aria-expanded="isActive"
      class="accordion-item__toggle button--unstyled hover--pointer flex flex-h-between"
      @click="toggleAccordionContent()">
      <label :for="toggleId" class="accordion-item__title">{{ title }}</label>
      <span class="material-icons">{{ arrow }}</span>
    </button>
    
    <transition name="accordion-toggle">
      <div v-show="isActive" role="region" :id="contentId" class="accordion-item__content-wrapper">
        <div class="accordion-item__content">
          <slot></slot>
        </div>
      </div>
    </transition>
  </div>  
</template>

<script>
  import { eventHub } from '../../../vue.js'

  export default {
    name: 'accordion-item',

    props: {
      id: {
        required: true,
        type: String
      },
      title: String,
      open: Boolean
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