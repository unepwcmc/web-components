<template>
  <div>
    {{ `This is ${currentTab}` }}
  </div>
</template>

<script>

export default {
  data () {
    return {
      currentTab: ''
    }
  },

  created () {
    this.$eventHub.$on('tab-change', tabId => {
      this.currentTab = tabId
    })
  }
}
</script>