<template>
  <g> 
    <path 
      :d="path" 
      :fill="areaChartFill"
      :stroke="colourLine" 
      :stroke-width="strokeWidth"
    />
    
    <!--     <template v-if="middle">
      <circle :cx="middle.x" :cy="middle.y" :fill="colour.line" r="18">{{ index + 1 }}</circle>
      <text :x="middle.x" :y="middle.y" :fill="colour.text" text-anchor="middle" dominant-baseline="middle" :font-size="fontSize" :font-weight="fontWeight">{{ index + 1 }}</text>
    </template> -->

    <!--     <template v-if="legend">
      <g :transform="`translate(${middle.x}, ${middle.y})`" v-html="createLabel(middle, index + 1)"></g>
    </template> -->

    <template v-if="hasLabels">
      <template v-for="(label, index) in labels">
        <g
          :key="getVForKey('label', index)"
          :transform="`translate(${label.x}, ${label.y})`"
          v-html="createLabel(label)"
        />
      </template>
    </template>
  </g>
</template>

<script>
import ChartDatapointLabel from './helpers/ChartDatapointLabel.js'
import mixinIds from '../../mixins/mixin-ids'
import { DEFAULT_COLOUR } from './helpers/chart-constants'

export default {
  name: 'ChartLineDataset',

  mixins: [mixinIds],

  props: {
    path: {
      type: String,
      required: true
    },
    colour: {
      type: Object,
      required: true
    },
    middle: {
      type: Object,
      default: () => {}
    },
    fontSize : {
      type: Number,
      default: 18
    },
    fontWeight : {
      type: Number,
      default: 900
    },
    legend: {
      type: Boolean,
      default: false
    },
    fill: {
      type: Boolean,
      default: false
    },
    labels: {
      type: Array,
      default: () => { return [] }
    },
    strokeWidth: {
      type: Number,
      default: 1
    }
  },

  computed: {
    hasLabels () {
      return this.labels.length > 0
    },

    colourLine () { return this.colour.line ? this.colour.line : DEFAULT_COLOUR.line },

    colourFill () { return this.colour.fill ? this.colour.fill : DEFAULT_COLOUR.fill },

    colourText () { return this.colour.text ? this.colour.text : DEFAULT_COLOUR.text },

    areaChartFill () { return this.fill ? this.colourFill : 'none' }
  },

  methods: {
    createLabel (label) {
      // const labelText = text ? text : label.text

      return new ChartDatapointLabel(label.x, label.y, label.value, this.colourLine, this.colourFill, this.colourText).createLabel()
    }
  }
}
</script>