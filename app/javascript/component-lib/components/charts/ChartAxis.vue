<template>
  <g>
    <text
      v-for="(number, index) in axisArray"
      :key="`chart-axis-${_uid}-text-${index}`"
      :x="getX(number)" 
      :y="getY(number)"
      :text-anchor="textAnchor"
      :font-size="config.fontSize"
      :fill="config.color"
      :label="config.label"
    >
      {{ number.labelText }}
    </text>

    <chart-axis-label 
      v-if="config.label" 
      :type="type"
      :label="config.label"
      :font-size="config.fontSize"
      :chart-padding="chartPaddingSides"
    />
  </g>
</template>

<script>
import ChartAxisLabel from './ChartAxisLabel.vue'
import { normaliseX } from './helpers/chart-helpers.js'
import { normaliseY } from './helpers/chart-helpers.js'

export default {
  name: 'ChartAxis',

  components: { ChartAxisLabel },

  props: {
    type: {
      type: String,
      required: true
    },
    config: {
      type: Object,
      required: true
    },
    size: {
      type: Number,
      required: true
    },
    min: {
      type: Number,
      required: true
    },
    max: {
      type: Number,
      required: true
    },
    x: {
      type: Number,
      default: 0
    },
    y: { 
      type: Number,
      default: 0
    },
    chartPaddingSides: {
      type: Number,
      default: 0
    }
  },

  data () {
    return {
      axisArray: ''
    }
  },

  computed: {
    textAnchor () {
      return this.type == 'y' ? 'end' : 'middle'
    }
  },

  mounted () {
    this.axisArray = this.createAxisArray()
  },

  methods: {
    getX (number) {
      if(this.type == 'x') {

        return number.coord
      } else {
        return this.x
      }
    },

    getY (number) {
      if(this.type == 'y') {
        return number.coord
      } else {
        return this.y
      }
    },

    createAxisArray () {
      let axisTickLabels = [], n = this.min
      const incrementor = (this.max - this.min)/(this.config.totalTicks - 1)
      
      while(n < this.max + incrementor) {
        axisTickLabels.push({
          coord: this[`normalise${this.type.toUpperCase()}`](n, this.min, this.max, this.size),
          labelText: Math.ceil(n/this.config.precision)*this.config.precision

          // sort out normalise function so that it uses if statement instead of being dynamic
        })

        n += incrementor
      }

      return axisTickLabels
    },

    normaliseX (value, min , max, size) { return normaliseX(value, min , max, size) },
    normaliseY (value, min , max, size) { return normaliseY(value, min , max, size) }
  }
}
</script>
