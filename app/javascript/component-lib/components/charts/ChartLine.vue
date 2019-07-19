<template>
  <div class="chart--line">
    <div class="chart__wrapper-ie11">
      <div class="chart__scrollable">
        <div 
          v-if="lines" 
          class="chart__chart" 
          style="width:100%;"
        >
          <svg 
            width="100%"
            height="100%"
            :viewBox="`-${chartPaddingSides} -${svgPaddingTop} ${config.width} ${config.height}`"
            xmlns="http://www.w3.org/2000/svg"
            preserveAspectRatio="xMidYMid"
            class="chart__svg"
          >
            <rect 
              :x="-chartPaddingSides"
              :y="-chartPaddingTop"
              :width="config.width" 
              :height="config.height" 
              :fill="svgBackgroundColour" 
            />

            <rect 
              :x="-chartPaddingSides"
              :y="-chartPaddingTop" 
              :rx="20"
              :width="config.width" 
              :height="backgroundHeight" 
              :fill="chartBackgroundColour"
            />

            <chart-axis
              v-if="xAxisConfig.showAxis"
              type="x"
              :min="x.min" 
              :max="x.max"
              :y="xAxisYDisplacement" 
              :config="xAxisConfig"
              :size="chartWidth"
            />

            <chart-axis
              v-if="yAxisConfig.showAxis"
              type="y"
              :min="y.min" 
              :max="y.max"
              :x="-chartPaddingLeft"
              :config="yAxisConfig"
              :size="chartHeight"
            />

            <chart-line-dataset 
              v-for="(line, index) in lines"
              :key="getVForKey('chart-line-dataset', index)"
              :index="index"
              :path="getPath(line.datapoints)"
              :labels="getDatapointLabels(line.datapoints)"
              :labelText="config.datapointLabelText"
              :colour="getLineColours(line)"
              :strokeWidth="config.strokeWidth"
              :datapointRadius="config.datapointRadius"
            />

            <template v-if="yTargets">
              <chart-line-target-y 
                v-for="(yTarget, index) in yTargets"
                :key="getVForKey('chart-line-target-y', index)"
                :minX="x.minNormalised" 
                :maxX="x.maxNormalised" 
                :y="normaliseY(yTarget.y)"
                :line-style="yTarget.lineStyle"
                :label="yTarget.label"
                :font-size="fontSize"
              />
            </template>

            <template v-if="xTargets">
              <chart-line-target-x 
                v-for="(xTarget, index) in xTargets"
                :key="getVForKey('chart-line-target-x', index)"
                :minY="y.minNormalised" 
                :maxY="y.maxNormalised" 
                :x="normaliseX(xTarget.x)"
                :line-style="xTarget.lineStyle"
                :label="xTarget.label"
                :font-size="fontSize"
              />
            </template>
          </svg>
        </div>
      </div>
    </div>

    <chart-legend 
      v-if="hasLegend" 
      :is-line="true" 
      :legend-items="legendDatasets"
    />
  </div>  
</template>

<script>
import ChartLineDataset from './ChartLineDataset'
import ChartAxis from './ChartAxis'
import ChartLineTargetX from './ChartLineTargetX.vue'
import ChartLineTargetY from './ChartLineTargetY.vue'
import { DEFAULT_COLOUR } from './helpers/chart-constants.js'
import { DEFAULT_SVG_CONFIG } from './helpers/chart-constants.js'
import mixinIds from '../../mixins/mixin-ids'

const AXIS_PADDING = 30
const DEFAULT_FONT_SIZE = 14


export default {
  name: 'ChartLine',

  components: { ChartLineDataset, ChartAxis, ChartLineTargetX, ChartLineTargetY },
  
  mixins: [mixinIds],

  props: {
    lines: {
      type: Array,
      required: true
    },
    xTargets: Array,
    yTargets: Array,
    axisLabels: Object,
    hasLegend: {
      type: Boolean,
      default: false
    },
    fontSize: {
      default: DEFAULT_FONT_SIZE,
      type: Number
    },
    options: {
      type: Object,
      default: () => { return { ...DEFAULT_SVG_CONFIG }}
    }
  }, 

  data () {
    return {
      x: {},
      y: {}
    }
  },

  computed: {
    xAxisConfig () { return {...DEFAULT_SVG_CONFIG.x, ...this.config.x }},
    yAxisConfig () { return {...DEFAULT_SVG_CONFIG.y, ...this.config.y }},

    config () { return {...DEFAULT_SVG_CONFIG, ...this.options}},

    svgBackgroundColour () { return this.config.svgBackgroundColour },
    chartBackgroundColour () { return this.config.chartBackgroundColour },

    backgroundHeight () { return this.config.height },

    chartHeight () { return this.backgroundHeight - this.chartPaddingTop - this.fontSize - this.chartPaddingBottom - this.xAxisConfig.offset },

    chartWidth () { return this.config.width - 2 * this.chartPaddingSides },

    chartPaddingLeft () { return AXIS_PADDING },

    chartPaddingSides () { return this.config.chartPaddingSides },

    svgPaddingTop () { return this.config.svgPaddingTop },
    chartPaddingTop () { return this.config.chartPaddingTop },
    chartPaddingBottom () { return this.config.chartPaddingBottom },

    xAxisYDisplacement () { return this.chartHeight + this.xAxisConfig.offset },

    legendDatasets () {
      const legendDatasets = []

      if (this.lines.length) {
        this.lines.forEach(line => {
          const legendDataset = {
            ...line,
            colour: this.getLineColours(line).line
          }

          legendDatasets.push(legendDataset)
        })
      }

      return legendDatasets
    }
  },

  created () {
    this.x.min = this.getMinMax('min', 'x')
    this.x.max = this.getMinMax('max', 'x')
    this.y.min = 0
    this.y.max = this.getMinMax('max', 'y')

    this.x.minNormalised = this.normaliseX(this.x.min)
    this.x.maxNormalised = this.normaliseX(this.x.max)
    this.y.minNormalised = this.normaliseY(this.y.min)
    this.y.maxNormalised = this.normaliseY(this.y.max)
  },

  methods: {
    getPath(dataset) {
      let path = ''
      
      dataset.forEach((point, index) => {
        const command = index == 0 ? 'M' : 'L'

        path += ` ${command} ${this.normaliseX(point.x)} ${this.normaliseY(point.y)}`
      })

      return path
    },

    getPathMiddle (dataset) {
      //used to add circle to a dataset with key used in the legend
      let middle = dataset[Math.floor(dataset.length/2)]

      return { x: this.normaliseX(middle.x), y: this.normaliseY(middle.y) }
    },

    getDatapointLabels (datapoints) {
      let labels = []

      if(this.config.datapointLabels == 'all') {
        datapoints.forEach(point => {
          let obj = {}
          
          obj['x'] = this.normaliseX(point.x) 
          obj['y'] = this.normaliseY(point.y)
          
          this.config.datapointLabelText ? obj['value'] = point.y : ''

          labels.push(obj)
        })
      }

      if(this.config.datapointLabels == 'middle') {
        const middle = datapoints[Math.floor(datapoints.length/2)]

        return [{ 
          x: this.normaliseX(middle.x), 
          y: this.normaliseY(middle.y) ,
          value: '' // fix this
        }]
      } 

      return labels
    },
    
    getLineColours (line) {
      let lineColours = line

      if(lineColours.colour) {
        if(!lineColours.colour.line) { lineColours.colour.line = DEFAULT_COLOUR.line }
        if(!lineColours.colour.fill) { lineColours.colour.fill = DEFAULT_COLOUR.fill }
        if(!lineColours.colour.text) { lineColours.colour.text = DEFAULT_COLOUR.text }
      } else {
        lineColours.colour = { line: DEFAULT_COLOUR.line, fill: DEFAULT_COLOUR.fill, text: DEFAULT_COLOUR.text }
      }

      return lineColours.colour
    },

    getMinMax(type, prop) {
      let array = []

      this.lines.forEach(line => {
        array.push(Math[type](...line.datapoints.map((t) => {
          return t[prop]
        })))
      }) 
    
      return Math.max(...array)
    },

    normaliseX (value) {
      // subtract the min value incase the axis doesn't start at 0
      return this.chartWidth * (value - this.x.min) / (this.x.max - this.x.min)
    },

    normaliseY (value) {
      // y origin is at the top so subtract axis value from height
      // subtract the min value incase the axis doesn't start at 0
      return this.chartHeight * (1 - (value - this.y.min) / (this.y.max - this.y.min))
    },
  }
}
</script>