<template>
  <div class="tabs">
    <ul
      role="tablist"
      class="tabs__triggers flex flex-nowrap"
    >
      <li 
        v-for="tab in tabs"
        :id="triggerId(tab)"
        :key="triggerId(tab)"
        role="tab"
        tabindex="0"
        :aria-controls="tabContainerId"
        :aria-selected="isSelected(tab)"
        :class="['tab__trigger flex-no-shrink hover--pointer', { 'tab__trigger--active' : isSelected(tab) }]" 
        @keypress.enter.prevent="click(tab)" 
        @keypress.space.prevent="click(tab)" 
        @click="click(tab)"
      >
        <label class="tab__title">
          {{ tab.label }}
        </label>
      </li>
    </ul>
    <div
      :id="tabContainerId"
      role="tabpanel"
      :aria-labelledby="triggerId(selectedTab)"
      class="tab__container"
    >
      <div class="tab">
        <slot />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FakeTabs',

  props: {
    initActiveId: {
      type: String,
      default: ''
    },
    tabs: { //{id: String, label: String, data: any}[]
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      selectedId: '',
      tabContainerId: 'tab-' + this._uid
    }
  },

  computed: {
    selectedTab () {
      let selectedTab = ''

      this.tabs.forEach(tab => {
        if (this.isSelected(tab)) {
          selectedTab = tab
        }
      })

      return selectedTab
    }
  },

  mounted () {
    this.initSelected()
  },

  methods: {
    click (tab) {
      this.selectedId = tab.id
      this.emitTabChange()
    },

    emitTabChange () {
      this.$eventHub.$emit('tab-change', this.selectedId)
    },

    initSelected () {
      this.selectedId = this.initSelectedId ? this.initSelectedId : this.tabs[0].id
      this.emitTabChange()
    },

    isSelected (tab) {
      return this.selectedId === tab.id
    },

    triggerId (tab) {
      return 'tab-trigger-' + tab.id
    }
  }
}
</script>