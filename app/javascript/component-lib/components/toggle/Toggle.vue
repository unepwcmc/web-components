<template>
  <div @click="toggle" :class="{ 'toggle-active': isActive }">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'toggle',

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