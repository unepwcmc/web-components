<template>
  <div class="chart--line">
    <div class="chart__wrapper-ie11">
      <div class="chart__scrollable">
        <div v-if="lines" class="chart__chart" style="width:100%;">
          <svg width="100%" height="100%" :viewBox="`-70 -80 ${svg.width} ${svg.height}`" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid" class="chart__svg">
            <rect 
              :x="-70"
              :y="-30" 
              :width="svg.width" 
              :height="svg.height - svg.paddingTop" 
              fill="#EBEBEB" />

            <text v-if="axisLabels" x="-70" y="-90" :font-size="fontSize">
              <tspan v-for="t in axisLabels.y" x="-70" dy="1.4em">{{ t }}</tspan>
            </text>

            <text v-for="y in yAxis" 
              :x="-x.chartPadding" 
              :y="y.coord "
              text-anchor="end"
              :font-size="fontSize"
              :font-weight="fontWeight"
              transform="translate(0, 5)">{{ y.labelText }}</text>

            <text v-for="x in xAxis" 
              :x="x.coord" 
              :y="y.chartHeight + y.chartPadding" 
              :font-size="fontSize"
              :font-weight="fontWeight"
              text-anchor="middle">{{ x.labelText }}</text>

            <chart-line-dataset 
              v-for="line, index in lines"
              :index="index"
              :path="getPath(line.datapoints)"
              :middle="getPathMiddle(line.datapoints)"
              :colour="getLineColourPair(line)">
            </chart-line-dataset>

            <template v-if="yTargets">
              <chart-line-target-y v-for="yTarget in yTargets"
                :minX="normaliseX(x.min)" 
                :maxX="normaliseX(x.max)" 
                :y="normaliseY(yTarget.y)"
                :line-style="yTarget.lineStyle"
                :label="yTarget.label">
              </chart-line-target-y>
            </template>

            <template v-if="xTargets">
              <chart-line-target-x v-for="xTarget in xTargets"
                :minY="normaliseY(y.min)" 
                :maxY="normaliseY(y.max)" 
                :x="normaliseX(xTarget.x)"
                :line-style="xTarget.lineStyle"
                :label="xTarget.label">
              </chart-line-target-x>
            </template>
          </svg>
        </div>
      </div>
    </div>

    <chart-legend v-if="hasLegend" :rows="legend"></chart-legend>
  </div>  
</template>

<script>
import ChartLineDataset from './ChartLineDataset'
import ChartLineTargetX from './ChartLineTargetX'
import ChartLineTargetY from './ChartLineTargetY'
import ChartLegend from './ChartLegend'

const DEFAULT_LINE_COLOUR = {
line: '#000000',
text: '#ffffff'
}

export default {
  name: 'chart-line',

  components: { ChartLineTargetX, ChartLineTargetY, ChartLineDataset, ChartLegend },

  props: {
    lines: {
      type: Array, // {datapoints: Datapoint[], colours: Colour[], title: String }[]
      required: true
    },
    xTargets: Array,
    yTargets: Array,
    axisLabels: Object,
    hasLegend: {
      type: Boolean,
      default: true
    },
    fontSize: {
      default: 'inherit',
      type: String
    },
    fontWeight: {
      type: String,
      default: 'inherit'
    },
  },

  data () {
    return {
      svg: {
        width: 1030,
        height: 650,
        paddingTop: 50
      },
      x: {
        precision: 1,
        chartWidth: 890, //TODO: calculate from width and height
        chartPadding: 24,
        min:0,
        max: 0,
        axisMarks: 10
      },
      y: {
        precision: 1,
        chartHeight: 500,
        chartPadding: 34,
        min: 0,
        max: 0,
        axisMarks: 8
      },
      yTargetColours: ['rgba(29, 125, 166, 0.4)', 'rgba(113, 163, 43, 0.4)']
    }
  },

  computed: {
    yAxis () {
      return this.getAxis('y')
    },

    xAxis () {
      return this.getAxis('x')
    },

    legend () {
      const lines = [...this.lines]

      if (lines.length) {
        lines.forEach(line => { 
          line.colour = this.getLineColourPair(line).line
        })
      }

      return lines
    }
  },

  created () {
    this.x.min = this.getMinMax('min', 'x')
    this.x.max = this.getMinMax('max', 'x')
    this.y.max = this.getMinMax('max', 'y')
    console.log(this.axisLabels)
  },

  methods: {
    getPath(dataset) {
      let path = ''
      
      dataset.forEach((point, index) => {
        let command = index == 0 ? 'M' : 'L'

        path += ` ${command} ${this.normaliseX(point.x)} ${this.normaliseY(point.y)}`
      })

      return path
    },

    getPathMiddle (dataset) {
      //used to add circle to a dataset with key used in the legend
      let middle = dataset[Math.floor(dataset.length/2)]

      return { x: this.normaliseX(middle.x), y: this.normaliseY(middle.y) }
    },

    getAxis (axis) {
      let array = [], n = this[axis].min
      const incrementor = (this[axis].max - this[axis].min)/ this[axis].axisMarks

      while( n < this[axis].max + incrementor) {
        array.push({
          coord: this[`normalise${axis.toUpperCase()}`](n),
          labelText: Math.ceil(n/this[axis].precision)*this[axis].precision
        })

        n += incrementor
      }

      return array
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
      return (((value - this.x.min) / (this.x.max - this.x.min)) * this.x.chartWidth)
    },

    normaliseY (value) {
      // y origin is at the top so subtract axis value from height
      // subtract the min value incase the axis doesn't start at 0
      return (this.y.chartHeight - ((value - this.y.min) / (this.y.max - this.y.min)) * this.y.chartHeight)
    },

    getLineColourPair (line) {
      return line.colour ? line.colour : DEFAULT_LINE_COLOUR
    }
  }
}
</script>