<template>
  <div
    class="modal"
    :class="{ 'modal--active' : isActive }"
    @click.self="closeModal"
  >
    <div
      role="dialog"
      aria-modal="true"
      class="modal__dialog"
    >
      <div class="modal__content">
        <button
          class="button--plain modal__close"
          @click="closeModal"
        >
          <span>close</span>
        </button>

        <slot />
      </div>
    </div>
  </div>
</template>

<script>
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'

export default {
  name: 'Modal',

  mixins: [
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeModal'}), 
    mixinPopupCloseListeners({closeCallback: 'closeModal', closeOnClickOutside: false})
  ],

  props: {
    id: {
      type: String,
      required: true
    }
  },

  computed: {
    isActive () {
      return this.$store.state.modal.isActive
    },

    mixinTriggerId () {
      return 'modal-trigger-' + this.id
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