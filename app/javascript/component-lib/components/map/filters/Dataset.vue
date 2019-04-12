<template>
  <div class="map-filters__filter flex" :class="{ 'map-filter--active': isActive}">
    <input type="radio" class="map-filters__default-radio-button hover--pointer" :checked="isActive" @click="toggleDataset">
    <i class="map-filters__radio-button hover--pointer"></i>
    <div class="map-filters__filter-container">
      <div class="map-filters__filter-legend">
        <h3 class="map-filters__filter-title">{{ name }}</h3>

        <div class="map-filters__filter-legend__gradient" :style="legendGradient"></div>

        <div class="map-filters__filter-legend__labels flex flex-h-between">
          <span>Low</span>
          <span>High</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
/**
 * This component holds the box for a specific datasets. It controls whether or not it is
 * visible by events that are received by Map.vue that shows/hides individual layers
 */
import { eventHub } from "../../../../vue.js"
import { getLayers } from "../helpers/map-helpers.js"

export default {
  name: "layer",
  props: {
    id: {
      required: true,
      type: String
    },
    config: Object
  },

  data() {
    return {
      selected: false,
      datasetLayersCreated: false,
      layerType: this.config.map_type,
      cartoColours: this.config.carto_colors,
      legend: this.config.legend,
      layerCount: this.config.carto_filters.length,
      name: this.config.name,
    }
  },

  mounted() {
    eventHub.$on("map-reload-layers", this.reloadDataset)
    eventHub.$on("deselect-" + this.datasetId, this.deselectDataset)
  },

  destroyed() {
    eventHub.$off("map-reload-layers", this.toggleDataset)
  },

  computed: {
    isActive() {
      return this.selected
    },

    legendGradient() {
      if (this.layerType === "Raster") {
        const colors = this.legend.join(", ")

        return {
          background: `linear-gradient(to right, ${colors})`
        }
      } else {
        const colors = this.cartoColours.join(", ")

        return {
          background: `linear-gradient(to right, ${colors})`
        }
      }
    },

    datasetId() {
      return `dataset_${this.id}_${this.name}`
    },

    layerGroup() {
      const layerGroup = {id: this.datasetId, layerIds: []}

      if (this.layerType === 'Raster') {
        layerGroup.layerIds.push(this.datasetId)
      } else {
        for (let i = 0; i < this.layerCount; i++) {
          layerGroup.layerIds.push(this.datasetId + "_" + i)
        }
      }

      return layerGroup
    }
  },

  methods: {
    toggleDataset() {
      this.selected ? this.deselectDataset() : this.selectDataset()
    },

    selectDataset() {
      this.selected = true
    },

    deselectDataset() {
      this.selected = false
    },

    reloadDataset() {
      this.datasetLayersCreated = false
      if(this.selected) {this.addDataset(true)}
    },

    addDataset(forceCreate=false) {
      this.createDatasetIfNecessary(forceCreate)
      this.setCurrentDataset()
    },

    createDatasetIfNecessary(forceCreate=false) {
      if (!this.datasetLayersCreated || forceCreate) {
        this.createDataset(this.selected)
      }
    },

    setCurrentDataset() {
      eventHub.$emit("map-set-curr", this.layerGroup)
    },

    hideDatasetLayers() {
      eventHub.$emit("map-hide-layers", this.layerGroup.layerIds)
    },

    createDataset(selected) {
      this.datasetLayersCreated = true
      getLayers(this.datasetId, this.config, selected).forEach(
        layer => { eventHub.$emit("map-create-layer", layer) }
      )
    }
  },

  watch: {
    selected(isSelected) {
      isSelected ? this.addDataset() : this.hideDatasetLayers()
    }
  }
}
</script>
