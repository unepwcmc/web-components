<template>
  <div
    :class="{ 'toggle-active': isActive }"
    @click="toggle"
  >
    <slot />
  </div>
</template>

<script>
export default {
  name: 'Toggle',

  data () {
    return {
      id: this._uid,
      isActive: false
    }
  },

  methods: {
    toggle () {
      this.isActive = !this.isActive
      this.$store.dispatch('toggle/updateToggleState', { id: this.id, isActive: this.isActive })
    }
  }
}
</script>