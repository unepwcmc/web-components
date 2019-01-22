<template>
  <div class="accordion-item">
    <button
      :id="toggleId"
      :aria-haspopup="true"
      :aria-controls="contentId"
      :aria-expanded="isActive"
      class="accordion-item__toggle flex flex-h-between"
      @click="toggleAccordionContent()">
      <label :for="toggleId" class="accordion-item__title">{{ title }}</label>
      <i class="material-icons">{{ arrow }}</i>
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

<style lang="scss">
  @keyframes open {
    from { max-height: 0; }
    to { max-height: 500px; }
  }

  @keyframes close {
    from { max-height: 500px; }
    to { max-height: 0; }
  }

  .accordion-toggle-enter-active {
    animation: open .5s forwards ease-in;
  }

  .accordion-toggle-leave-active {
    animation: close .5s forwards ease-out;
  }

  .accordion-item {
    &__toggle {
      cursor: pointer;
    }

    &__content-wrapper {
      overflow: hidden;
      height: auto;
    }
  }
</style>
