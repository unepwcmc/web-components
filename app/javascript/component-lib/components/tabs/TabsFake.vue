<template>
  <ul class="tabs--fake">
    <tab-fake
      v-for="(child, index) in children" 
      :id="child.id"
      :key="index"
      :selected-id="selectedId"
      :title="child.title"
      @click:tab="click"
    />
  </ul>
</template>

<script>
import TabFake from './TabFake.vue'

export default {
  name: 'TabsFake',

  components: { TabFake },

  props: {
    children: {
      type: Array, // [{ id: String, title: String }]
      required: true
    },
    preSelected: {
      default: '',
      type: String
    }
  },

  data () {
    return {
      defaultId: this.children[0].id,
      selectedId: ''
    }
  },

  created () {
    this.setInitialTab()
    this.$eventHub.$on('reset:tabs', this.reset)
  },

  methods: {
    click (selectedId) {
      this.selectedId = selectedId

      this.$emit('click:tab', selectedId)
    },

    reset () {
      this.selectedId = this.defaultId
    },

    setInitialTab () {
      let tabId = this.defaultId

      if(this.preSelected !== '') {
        if(this.children.filter(child => child.id == this.preSelected)) { 
          tabId = this.preSelected 
        }
      }
      
      this.click(tabId)
    }
  }
}
</script>