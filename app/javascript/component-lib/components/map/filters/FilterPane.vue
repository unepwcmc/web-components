<template>
  <div
    class="map-pane"
    :class="{ 'map-pane--active' : isActive}"
  >
    <button
      id="map-pane-close"
      class="map-pane__close hover--pointer"
      @click.prevent="togglePane"
    >
      {{ paneIcon }}
    </button>

    <div class="map-pane__content">
      <filters :filters="filtersArray" />
    </div>
  </div>
</template>

<script>
import { eventHub } from '../../../../vue.js'
import { EXAMPLE_FILTERS } from '../helpers/example-layers.js'
import Filters from './Filters.vue'
import mixinDisableTabbing from '../../../mixins/mixin-disable-tabbing'

export default {
  name: 'FilterPane',

  components: { Filters },

  mixins: [mixinDisableTabbing('isActive')],

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      isActive: true,
      filtersArray: EXAMPLE_FILTERS
    }
  },

  computed: {
    paneIcon() {
      return this.isActive ? '>' : '<'
    }
  },

  created() {
    eventHub.$on('reload-all-facets', this.reload)
  },

  destroyed() {
    eventHub.$off('reload-all-facets', this.reload)
  },

  methods: {
    togglePane() {
      this.isActive ? this.closePane() : this.openPane()
    },
    
    openPane() {
      this.isActive = true
    },

    closePane() {
      this.isActive = false
    },

    reload() {
      //reload data, possibly with request, here
      this.filtersArray = EXAMPLE_FILTERS
    }
  }
}
</script>