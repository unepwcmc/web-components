<template>
  <button
    :id="triggerId"
    class="modal__trigger"
    aria-haspopup="dialog"
    @click="openModal"
  >
    <slot />
  </button>
</template>

<script>
export default {
  name: 'ModalTrigger',

  props: {
    id: {
      type: String,
      required: true
    }
  },

  computed: {
    triggerId () {
      return 'modal-trigger-' + this.id
    }
  },

  methods: {
    openModal () {
      this.$store.commit('modal/updateModalStatus')
    }
  }
}
</script>
