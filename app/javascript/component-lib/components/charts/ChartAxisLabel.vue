<template>
  <text 
    :x="-chartPaddingSides" 
    :y="-4.5 * font" 
    :font-size="font"
  >
    <tspan 
      v-for="text in label" 
      :x="-chartPaddingSides" 
      :dy="1.25 * font"
    >{{ text }}
    </tspan>

  </text>
</template>

<script>
import { DEFAULT_SVG_CONFIG } from './helpers/chart-constants.js'

export default {
  name: 'chart-axis-label',

  props: {
    label: {
      type: Array,
      required: true
    },
    type: {
      type: String,
      required: true
    },
    fontSize: Number,
    chartPadding: Number
  },

  computed: {
    font () { return this.fontSize ? this.fontSize : DEFAULT_SVG_CONFIG[this.type].fontSize },

    chartPaddingSides () { return this.chartPadding ? this.chartPadding : DEFAULT_SVG_CONFIG.chartPaddingSides },
  }
}
</script>