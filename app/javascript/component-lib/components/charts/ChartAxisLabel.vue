<template>
  <text 
    :x="-chartPaddingSides" 
    :y="-4.5 * font" 
    :font-size="font"
  >
    <tspan 
      v-for="(text, index) in label"
      :key="`chart-axis-label-${_uid}-text-${index}`"
      :x="-chartPaddingSides" 
      :dy="1.25 * font"
    >
      {{ text }}
    </tspan>
  </text>
</template>

<script>
import { DEFAULT_SVG_CONFIG, DEFAULT_FONT } from './helpers/chart-constants.js'

export default {
  name: 'ChartAxisLabel',

  props: {
    label: {
      type: Array,
      required: true
    },
    type: {
      type: String,
      required: true
    },
    fontSize: {
      type: Number,
      default: DEFAULT_FONT.size
    },
    chartPadding: {
      type: Number,
      default: DEFAULT_SVG_CONFIG.chartPaddingTop
    }
  },

  computed: {
    font () { return this.fontSize ? this.fontSize : DEFAULT_SVG_CONFIG[this.type].fontSize },

    chartPaddingSides () { return this.chartPadding ? this.chartPadding : DEFAULT_SVG_CONFIG.chartPaddingSides },
  }
}
</script>