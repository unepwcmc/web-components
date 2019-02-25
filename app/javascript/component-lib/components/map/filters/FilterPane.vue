<template>
  <div class="map-pane--target" :class="{ 'map-pane--target--active' : isActive}">
    <button @click.prevent="togglePane" class="map-pane--target__close hover--pointer">{{paneIcon}}</button>

    <div class="map-pane--target__content">
      <filters :filters="filtersArray"></filters>
    </div>
  </div>
</template>

<script>
import helpers from "../../../helpers/helpers.js"
import { eventHub } from "../../../../vue.js"
import { EXAMPLE_FILTERS } from "../helpers/example-layers.js"
import Filters from "./Filters.vue"

export default {
  name: "filter-pane",

  components: { Filters },

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
      return this.isActive ? ">" : "<"
    }
  },

  created() {
    eventHub.$on("reload-all-facets", this.reload)
  },

  destroyed() {
    eventHub.$off("reload-all-facets", this.reload)
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

    reload(e) {
      //reload data, possibly with request, here
      this.filtersArray = EXAMPLE_FILTERS
    }
  }
}
</script>

<style lang="scss">
.dummy-class-for-deploy-to-be-removed{
  display: none;
}
</style>
