<template>
  <div
    v-show="isActive"
    :id="id"
    role="tabpanel"
    :aria-labelledby="triggerId"
    class="tab"
  >
    <slot />
  </div>
</template>

<script>
export default {
  name: 'Tab',
  props: {
    id: {
      required: true,
      type: String
    },
    title: {
      required: true,
      type: String
    }
  },
  data() {
    return {
      isActive: false
    }
  },

  computed: {
    triggerId () {
      return 'tab-trigger-' + this.id
    }
  }
}
</script>