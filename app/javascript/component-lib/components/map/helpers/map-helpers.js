import { isTabForward, isTabBackward } from '../../../helpers/focus-helpers'

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

  if (config.map_type === 'Raster') {
    layers.push(layer)
  } else {
    //Vector datasets contain multiple layers
    for (let i = 0; i < config.carto_filters.length; i++) {
      const cartoLayer = {
        carto: {
          filter: config.carto_filters[i],
          tables: [config.carto_table],
          colour: config.carto_colors[i],
          id: datasetId + '_' + i
        },
        ...layer
      }

      layers.push(cartoLayer)
    }
  }

  return layers
}

export const getFirstForegroundLayerId = map => {
  let firstBoundaryId = ''
  let firstSymbolId = ''

  for (const layer of map.getStyle().layers) {
    if (layer.id.match('admin') && layer.id.match('boundaries')) {
      firstBoundaryId = layer.id
      break
    } else if (layer.type === 'symbol') {
      firstSymbolId = layer.id
    }
  }

  return firstBoundaryId || firstSymbolId
}

export const correctTabFlow = mapWrapper => {
  mapWrapper
    .querySelector('.mapboxgl-ctrl-geocoder--input')
    .addEventListener('keydown', e => {
      if (isTabForward(e)) {
        e.preventDefault()
        mapWrapper.querySelector('#map-pane-close').focus()
      } else if (isTabBackward(e)) {
        e.preventDefault()
        mapWrapper.querySelector('.mapboxgl-canvas').focus()
      }
    })

  mapWrapper
    .querySelector('#map-pane-close')
    .addEventListener('keydown', e => {
      if (isTabBackward(e)) {
        e.preventDefault()
        mapWrapper
          .querySelector('.mapboxgl-ctrl-geocoder--input')
          .focus()
      }
    })
}