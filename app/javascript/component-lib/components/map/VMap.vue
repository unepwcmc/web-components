
<template>
  <div class="map__container">
    <div class="map__wrapper">
      <div
        :id="id"
        class="map"
      />
    </div>
    <filter-pane id="filters-layers" />
  </div>
</template>

<script>
/* eslint-disable no-undef */
/**
 * MapExplore is the main map panel and most of the functionality comes from turf & mixin-carto
 * This component just handles 'mapbox layers' on the map and knows nothing about our 'datasets' which may contain
 * multiple layers
 * Key events:
 *   map-create-layer: creates a single map layer with given id
 *   map-hide-layers: hide the layer with provided id (must already have been created)
 */
import LayersControl from './helpers/layers-control.js'
import { getFirstForegroundLayerId, correctTabFlow } from './helpers/map-helpers.js'
import mixinCarto from './mixins/mixin-carto.js'
import mixinAddLayers from './mixins/mixin-add-layers.js'
import { eventHub } from '../../../vue.js'
import FilterPane from './filters/FilterPane'

export default {

  components: {
    FilterPane
  },
  mixins: [mixinCarto, mixinAddLayers],

  data() {
    return {
      id: 'map--type',
      currentLayerSetId: null,
      mapboxToken:
        'pk.eyJ1IjoibGV2aWF0aGFuczE3IiwiYSI6ImNpeDd5YWIzZTAwM3Myb29jaHNleW02YTgifQ.KOR1dSr7sTbWUtXw4V6tpA',
      cartoUsername: 'carbon-tool',
      cartoApiKey: 'f7762e628586b3ff41a371b8e89ea0069e975299',
      firstForegroundLayerId: ''
    }
  },

  mounted() {
    eventHub.$on('map-create-layer', this.addLayer)
    eventHub.$on('map-hide-layers', this.hideLayers)
    eventHub.$on('map-set-curr', this.setLayers)

    mapboxgl.accessToken = this.mapboxToken

    const map = new mapboxgl.Map({
      container: this.id,
      style: 'mapbox://styles/mapbox/light-v9',
      pitchWithRotate: false,
      center: [0, 30],
      zoom: 1
    })

    this.map = map

    /** This event is for when mapbox style is changed on e.g. to 'streets' or 'basic'
     * so we reload all layers on the new map
     */
    map.on('style.load', () => {
      this.setFirstForegroundLayerId()
      eventHub.$emit('map-reload-layers', map.isStyleLoaded())
    })

    map.on('load', () => {
      const navControl = new mapboxgl.NavigationControl()
      const layersControl = new LayersControl()

      const geocoderControl = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        flyTo: true,
        zoom: false
      })

      /** mapBox specific controls */
      map.addControl(layersControl, 'bottom-left')
      map.addControl(navControl, 'bottom-left')
      map.addControl(geocoderControl, 'top-left')
      this.setFirstForegroundLayerId()
      correctTabFlow(this.$el)
    })
  },

  methods: {
    setFirstForegroundLayerId () {
      this.firstForegroundLayerId = getFirstForegroundLayerId(this.map)
    },

    addLayer(layer) {
      if (layer.type === 'Raster') {
        this.addRasterLayer(layer, this.firstForegroundLayerId)
      } else {
        this.addVectorLayer(layer, this.firstForegroundLayerId)
      }
    },

    setLayers(layerSet) {
      if (this.currentLayerSetId !== layerSet.id) {
        eventHub.$emit('deselect-' + this.currentLayerSetId)
        this.currentLayerSetId = layerSet.id
      }

      if (layerSet.id !== null) { this.showLayers(layerSet.layerIds) }
    },

    showLayers(layerIds) {
      this.setLayerVisibilities(layerIds, true)
    },

    hideLayers(layerIds) {
      this.setLayerVisibilities(layerIds, false)
    },

    setLayerVisibilities(layerIds, isVisible) {
      layerIds.forEach(id => {
        this.setLayerVisibility(id, isVisible)
      })
    },

    setLayerVisibility(layerId, isVisible) {
      const visibility = isVisible ? 'visible' : 'none'

      if (this.map.getLayer(layerId)) {
        this.map.setLayoutProperty(layerId, 'visibility', visibility)
      }
    },
  }
}
</script>