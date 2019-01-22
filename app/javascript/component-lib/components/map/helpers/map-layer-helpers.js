export const getLayers = (datasetId, config, isSelected) => {
  const layers = []
  const layer = {
    name: datasetId,
    type: config.map_type,
    visible: isSelected,
    mapbox: {
      tileset: config.tileset
    }
  }

  if (config.map_type === "Raster") {
    layers.push(layer)
  } else {
    //Vector datasets contain multiple layers
    for (let i = 0; i < config.carto_filters.length; i++) {
      const cartoLayer = {
        carto: {
          filter: config.carto_filters[i],
          tables: [config.carto_table],
          colour: config.carto_colors[i],
          id: datasetId + "_" + i
        },
        ...layer
      }

      layers.push(cartoLayer)
    }
  }

  return layers
}