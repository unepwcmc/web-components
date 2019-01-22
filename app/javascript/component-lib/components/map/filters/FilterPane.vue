<template>
  <div class="pane--target" :class="{ 'pane--target--active' : isActive}">
    <button @click.prevent="togglePane" class="pane--target__close">{{paneIcon}}</button>

    <div class="pane--target__content">
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
.pane {
  &--target {
    color: white;
    padding-left: 30px;
    width: 100%;

    position: absolute;
    right: 0;
    bottom: 0;
    top: 0;
    z-index: 1000;

    transform: translateX(100%) translateX(-40px);

    transition: transform 0.4s ease-in-out;

    &--active {
      transform: translateX(0);
    }

    &__content {
      background-color: black;
      overflow-y: scroll;
      height: 100%;
    }

    &__close {
      width: 30px;

      position: absolute;
      top: 0;
      left: 0;
    }
  }
}
.filters {
  &__filter {
    &-legend {
      &__image,
      &__gradient {
        border-radius: 15px;
        height: 15px;
        overflow: hidden;
        text-align: center;
        width: 100%;

        img {
          transform: rotateZ(90deg);
          width: 100%;
        }
      }
    }
  }
}
</style>
