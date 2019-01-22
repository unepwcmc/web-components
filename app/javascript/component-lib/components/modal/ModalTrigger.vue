<template>
  <button
    id="modal-trigger"
    class="modal__trigger button--beige-dark"
    aria-haspopup="dialog"
    @click="openModal"><slot></slot></button>
</template>

<script>
export default {
  name: 'modal-trigger',

  methods: {
    openModal () {
      this.$store.commit('modal/updateModalStatus')
    }
  }
}
</script>
