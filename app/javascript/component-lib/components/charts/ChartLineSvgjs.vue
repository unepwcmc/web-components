<template>
  <div class="chart--line">
    <div class="chart__wrapper-ie11">
      <div class="chart__scrollable">
        <div v-if="lines" class="chart__chart" style="width:100%;">
          <div id="drawing"></div>
        </div>
      </div>
    </div>

    <chart-legend v-if="hasLegend" :is-line="true" :legend-items="legendDatasets"></chart-legend>
  </div>  
</template>

<script>
import ChartLineDataset from './ChartLineDataset'
import ChartLineTargetX from './ChartLineTargetX'
import ChartLineTargetY from './ChartLineTargetY'
import ChartLegend from './ChartLegend'
import SVG from 'svg.js'
import Chart from './helpers/Chart.js'

const AXIS_PADDING = 30
const DEFAULT_BACKGROUND_COLOUR = '#eeeeee'
const DEFAULT_CHART_PADDING_SIDES = 80
const DEFAULT_FONT_SIZE = 14
const DEFAULT_LINE_COLOUR = {
line: '#000000',
text: '#ffffff'
}
const DEFAULT_SVG_CONFIG = {
  width: 1000,
  height: 650
}
const DEFAULT_X_AXIS_CONFIG = {
  precision: 1,
  axisMarks: 10
}
const DEFAULT_Y_AXIS_CONFIG = {
  precision: 1,
  axisMarks: 8
}

export default {
  name: 'chart-line',

  components: { ChartLineTargetX, ChartLineTargetY, ChartLineDataset, ChartLegend },

  props: {
    lines: {
      type: Array, // Line[]
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
      default: DEFAULT_FONT_SIZE,
      type: Number
    },
    xAxisConfig: Object,
    yAxisConfig: Object,
    chartPaddingSides: {
      type: Number,
      default: DEFAULT_CHART_PADDING_SIDES
    },
    backgroundColour: {
      type: String,
      default: DEFAULT_BACKGROUND_COLOUR
    },
    svgConfig: Object
  },

  computed: {
    x () { return {...DEFAULT_X_AXIS_CONFIG, ...this.xAxisConfig} },

    y () { return {...DEFAULT_Y_AXIS_CONFIG, ...this.yAxisConfig} },

    svg () { return {...DEFAULT_SVG_CONFIG, ... this.svgConfig} },

    yAxis () { return this.getAxis('y') },

    xAxis () { return this.getAxis('x') },

    backgroundHeight () {return this.svg.height - this.svgPaddingTop },

    chartHeight () {return this.backgroundHeight - this.chartPaddingTop - this.fontSize - this.chartPaddingBottom },

    chartWidth () {return this.svg.width - 2 * this.chartPaddingSides },

    chartPaddingBottom () { return this.fontSize + AXIS_PADDING },

    chartPaddingLeft () { return AXIS_PADDING },

    chartPaddingTop () { return this.fontSize * 1.5 },

    svgPaddingTop () {return this.chartPaddingTop + this.fontSize * 3 },

    xAxisYDisplacement () { return this.chartHeight + this.chartPaddingBottom },

    legendDatasets () {
      const legendDatasets = []

      if (this.lines.length) {
        this.lines.forEach(line => {
          const legendDataset = {
            ...line,
            colour: '#000000'//this.getLineColourPair(line).line
          }

          legendDatasets.push(legendDataset)
        })
      }

      return legendDatasets
    }
  },

  mounted () {
    const draw = SVG('drawing').size('100%', '100%').viewbox(0,0,this.svg.width, this.svg.height)

    const container = draw.group()
    container.rect(this.svg.width, this.backgroundHeight).fill(this.backgroundColour)

    const chart = new Chart({
      lines: this.lines,
      parent: container,
      width: this.chartWidth,
      height: this.chartHeight
    })

    const chartBackground = chart.background('#ffffff')
    const xAxis = chart.xAxis({tickCount: 10, precision: 1})
    const yAxis = chart.yAxis({tickCount: 8, precision: 1})

    xAxis.text('Axis label').move(this.chartWidth/2, 20).font({anchor: 'middle'})

    const chartLines = chart.chartLines()
    container.move(0,50)
    chart.g.move(80, 50)
    xAxis.move(0, this.chartHeight + 5)
    yAxis.move(-20, - this.fontSize / 2)
  }
}
</script>