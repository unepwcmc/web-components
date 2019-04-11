
<template>
  <div class="map__container">
    <div class="map-wrapper">
      <div :id="id" class="map"></div>
    </div>
    <filter-pane id="filters-layers"></filter-pane>
  </div>
</template>

<script>
/**
 * MapExplore is the main map panel and most of the functionality comes from turf & mixin-carto
 * This component just handles 'mapbox layers' on the map and knows nothing about our 'datasets' which may contain
 * multiple layers
 * Key events:
 *   map-create-layer: creates a single map layer with given id
 *   map-hide-layers: hide the layer with provided id (must already have been created)
 */
import * as turf from "@turf/turf"

import LayersControl from "./helpers/layers-control.js"
import { getFirstSymbolLayerId } from "./helpers/map-layer-helpers.js"
import { mixinCarto } from "./mixins/mixin-carto.js"
import { eventHub } from "../../../vue.js"
import FilterPane from "./filters/FilterPane"

export default {
  mixins: [mixinCarto],

  components: {
    FilterPane
  },

  data() {
    return {
      id: "map--type",
      currentLayerSetId: null,
      mapboxToken:
        "pk.eyJ1IjoibGV2aWF0aGFuczE3IiwiYSI6ImNpeDd5YWIzZTAwM3Myb29jaHNleW02YTgifQ.KOR1dSr7sTbWUtXw4V6tpA",
      cartoUsername: "carbon-tool",
      cartoApiKey: "f7762e628586b3ff41a371b8e89ea0069e975299",
      firstSymbolLayerId: ''
    }
  },

  mounted() {
    eventHub.$on("map-create-layer", this.addLayer)
    eventHub.$on("map-hide-layers", this.hideLayers)
    eventHub.$on("map-set-curr", this.setLayers)

    mapboxgl.accessToken = this.mapboxToken

    const map = new mapboxgl.Map({
      container: this.id,
      style: "mapbox://styles/mapbox/light-v9",
      pitchWithRotate: false,
      center: [0, 30],
      zoom: 1
    })

    this.map = map

    /** This event is for when mapbox style is changed on e.g. to 'streets' or 'basic'
     * so we reload all layers on the new map
     */
    map.on("style.load", () => {
      this.setFirstSymbolLayerId()
      eventHub.$emit("map-reload-layers", map.isStyleLoaded())
    })

    map.on("load", () => {
      const navControl = new mapboxgl.NavigationControl()
      const layersControl = new LayersControl()

      const geocoderControl = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        flyTo: true,
        zoom: false
      })

      /** mapBox specific controls */
      map.addControl(layersControl, "bottom-left")
      map.addControl(navControl, "bottom-left")
      map.addControl(geocoderControl, "top-left")
      this.setFirstSymbolLayerId()
    })
  },

  methods: {
    setFirstSymbolLayerId () {
      this.firstSymbolLayerId = getFirstSymbolLayerId(this.map)
    },

    addLayer(layer) {
      if (layer.type === "Raster") {
        this.addRasterLayer(layer)
      } else {
        this.addVectorLayer(layer)
      }
    },

    addRasterLayer(layer) {
      // Mapbox tileset
      if (layer.mapbox && layer.mapbox.tileset) {
        this.map.addSource(layer.name, {
          type: "raster",
          url: `mapbox://${layer.mapbox.tileset}`,
          tileSize: 256
        })

      // Generic tile endpoint
      } else if (layer.mapbox && layer.mapbox.endpoint) {
        this.map.addSource(layer.name, {
          type: "raster",
          tiles: [layer.mapbox.endpoint],
          tileSize: 256
        })
      }

      this.map.addLayer({
        id: layer.name,
        type: "raster",
        source: layer.name,
        paint: {
          "raster-resampling": "nearest"
        },
        layout: {
          visibility: layer.visible ? "visible" : "none"
        }
      }, this.firstSymbolLayerId)

      this.map.setPaintProperty(layer.name, "raster-opacity", 0.5)
    },

    addVectorLayer(layer) {
      if (layer.type === "Vector") {
        this.createVectorShapeLayer(layer.visible, layer.carto)
      } else if (layer.type === "VectorLine") {
        this.createVectorLineLayer(layer.visible, layer.carto)
      }
    },

    createVectorShapeLayer(visible, carto) {
      const tiles = this.createCartoTiles(carto)

      tiles.getTiles(() => {
        this.map.addSource(carto.id, {
          type: "vector",
          tiles:
            tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
        })

        this.map.addLayer({
          id: carto.id,
          type: "fill",
          source: carto.id,
          "source-layer": "layer0",
          paint: {
            "fill-color": carto.colour
              ? carto.colour
              : `#${(Math.random().toString(16) + "000000").substring(2, 8)}`,
            "fill-opacity": 0.5
          },
          layout: {
            visibility: visible ? "visible" : "none"
          }
        }, this.firstSymbolLayerId)
      })
    },
    createVectorLineLayer(visible, carto) {
      const tiles = this.createCartoTiles(carto)

      tiles.getTiles(() => {
        this.map.addSource(carto.id, {
          type: "vector",
          tiles:
            tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
        })
        this.map.addLayer({
          id: carto.id,
          type: "line",
          source: carto.id,
          "source-layer": "layer0",
          paint: {
            "line-width": 3,
            "line-color": carto.colour
          },
          layout: {
            visibility: visible ? "visible" : "none"
          }
        }, this.firstSymbolLayerId)
      })
    },

    createCartoTiles(carto) {
      return this.createTiles(this.cartoUsername, this.cartoApiKey, carto)
    },

    setLayers(layerSet) {
      if (this.currentLayerSetId !== layerSet.id) {
        eventHub.$emit("deselect-" + this.currentLayerSetId)
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
        this.map.setLayoutProperty(layerId, "visibility", visibility)
      }
    },
  }
}
</script>