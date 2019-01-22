<template>
  <div class="modal" :class="{ 'modal--active' : isActive }" @click.self="closeModal">
    <div role="dialog" aria-modal="true" class="modal__dialog">

      <div class="modal__content">
        <button class="button--plain modal__close" @click="closeModal">
          <i>close</i>
        </button>

        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
import { eventHub } from '../../../vue.js'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'

export default {
  name: 'modal',

  mixins: [mixinFocusCapture('isActive'), mixinPopupCloseListeners('closeModal', false, true)],

  data() {
    return {
      mixinTriggerId: 'modal-trigger',
    }
  },

  computed: {
    isActive () {
      return this.$store.state.modal.isActive
    }
  },

  methods: {
    toggleModal () {
      this.$store.commit('modal/updateModalStatus')
    },

    closeModal () {
      this.toggleModal()
    }
  }
}
</script>

<style lang="scss">
.modal {
  background-color: rgba(black, .6);
  
  display: none;
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 300;

  &--active { display: block; }

  &__dialog {
    background-color: white;

    position: absolute;
    top: 50%;
    right: 50%;
  }
}
</style>