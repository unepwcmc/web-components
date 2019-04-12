export default {
  methods: {
    addRasterLayer (layer, nextLayerId) {
      const sourceOptions = {
        type: "raster",
        tileSize: 256
      }
      // Mapbox tileset
      if (layer.mapbox && layer.mapbox.tileset) {
        sourceOptions.url = `mapbox://${layer.mapbox.tileset}`
      // Generic tile endpoint
      } else if (layer.mapbox && layer.mapbox.endpoint) {
        sourceOptions.tiles = [layer.mapbox.endpoint]
      }

      this.map.addLayer({
        id: layer.name,
        type: "raster",
        source: sourceOptions,
        paint: {
          "raster-resampling": "nearest",
          "raster-opacity": 0.5
        },
        layout: {
          visibility: layer.visible ? "visible" : "none"
        }
      }, nextLayerId)
    },

    createCartoTiles(carto) {
      return this.createTiles(this.cartoUsername, this.cartoApiKey, carto)
    },

    addVectorLayer(layer, nextLayerId) {
      const carto = layer.carto
      const tiles = this.createCartoTiles(carto)
      const isLineType = layer.type === "VectorLine"

      tiles.getTiles(() => {
        const options = {
          id: carto.id,
          type: isLineType ? "line" : "fill",
          source: {
            type: "vector",
            tiles: tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
          },
          "source-layer": "layer0",
          layout: {
            visibility: layer.visible ? "visible" : "none"
          }
        }

        if (isLineType) {
          options.paint = {
            "line-width": 3,
            "line-color": carto.colour
          }
        } else {
          options.paint = {
            "fill-color": carto.colour
              ? carto.colour
              : `#${(Math.random().toString(16) + "000000").substring(2, 8)}`,
            "fill-opacity": 0.5
          }
        }
        
        this.map.addLayer(options, nextLayerId)
      })
    }
  }
}
