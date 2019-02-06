<template>
  <div :id="svgId" class="d3-horizontal-bar-chart sm-bar-chart"></div>
</template>

<script>
import * as d3 from 'd3'
import ScrollMagic from 'scrollmagic'

const DEFAULT_CONFIG = {
  width: 550,
  height: 240,
  marginLeft: 50, 
  marginRight: 20,
  marginBottom: 30,

  sortByValue: true,
  unit: '%',
  barLabelPadding: 10,
  
  yDomainPadding: .5,
  yTickPadding: 10,
  yTickSize: 0,

  xAxisMax: 100,
  xTickCount: 6,
  xTickPadding: 10,
  xTickSize: 0,
}

export default {
  name: "horizontal-bar-chart",

  props: {
    id: String,
    data: Array, // {name: String, value: Number}[]
    chartConfig: Object
  },

  data () {
    return {
      config: {},
      chartWidth: 0,
      chartHeight: 0,
      svgId: 'd3-horizontal-bar-chart',
      chart: {},
      x: {},
      y: {}
    }
  },

  created () {
    this.config = {...DEFAULT_CONFIG, ...this.chartConfig}
    this.chartWidth = this.config.width - this.config.marginLeft - this.config.marginRight
    this.chartHeight = this.config.height - this.config.marginBottom
    this.svgId = 'd3-' + this.id
  },

  mounted () {
    this.renderChart()
    //TODO: generate scenes 
    const chartScrollMagic = new ScrollMagic.Controller()

    new ScrollMagic.Scene({ triggerElement: '.sm-bar-chart', reverse: false })
      .setClassToggle('.sm-bar-chart', 'd3-horizontal-bar-chart-animate')
      .addTo(chartScrollMagic)
  },

  methods: {
    renderChart () {
      this.initChartAndScales()
      this.sortData()
      this.initXDomain()
      this.initYDomain()
      this.addChartBackground()
      this.addXAxis()
      this.addYAxis()
      this.addGridlines()   
      this.addBars()
    },

    initChartAndScales () {
      this.chart = this.createSVG().append('g')
        .attr('transform', 'translate(' + this.config.marginLeft + ', 0)')

      this.x = d3.scaleLinear().range([0, this.chartWidth])
      this.y = d3.scaleBand().range([this.chartHeight, 0])
    },

    sortData() {
      if(this.config.sortByValue) { this.data.sort((a, b) =>  a.value - b.value) }
    },

    initXDomain() {
      if(this.config.xAxisMax){
        this.x.domain([0, this.config.xAxisMax])
      } else {
        this.x.domain([0, d3.max(this.data, d => d.value)])
      }
    },

    initYDomain() {
      this.y.domain(this.data.map(d => d.name)).padding(this.config.yDomainPadding)
    },

    addChartBackground() {
      this.chart.append('rect')
        .attr('width', this.chartWidth)
        .attr('height', this.chartHeight)
        .attr('class', 'background')
    },

    addXAxis() {
      this.chart.append('g')
        .attr('class', 'xaxis')
        .attr('transform', `translate(0, ${this.chartHeight})`)
        .call(
          d3.axisBottom(this.x)
            .ticks(this.config.xTickCount)
            .tickSize(this.config.xTickSize)
            .tickPadding(this.config.xTickPadding)
        )
    },

    addYAxis() {
      this.chart.append('g')
        .attr('class', 'yaxis')
        .call(d3.axisLeft(this.y).tickSize(this.config.yTickSize).tickPadding(this.config.yTickPadding))
        .selectAll('.tick text')
        .call(this.wrap, this.config.marginLeft - this.config.yTickPadding)
    },

    addGridlines() {
      this.chart.append('g')
        .attr('class', 'gridlines')
        .attr('transform', 'translate(0, ' + this.chartHeight + ')')
        .call(d3.axisBottom(this.x).ticks(this.config.xTickCount).tickSize(-this.chartHeight, 0, 0).tickFormat(''))
    },

    addBars() {
      const bar = this.chart.selectAll('.bar')
        .data(this.data)
        .enter().append('g')
        .attr('transform', d => `translate(0,${this.y(d.name)})`)

      bar.append('rect')
        .attr('class', 'bar')
        .attr('x', 0)
        .attr('y', 0)
        .attr('height', this.y.bandwidth())
        .attr('width', d => this.x(d.value))
      
      const isBarShort = d => d.value/this.config.xAxisMax < 0.1

      bar.append('text')
        .attr('class', d => isBarShort(d) ? 'bar-label bar-label--small-bar': 'bar-label')
        .attr('transform', d => {           
          const paddingDirection = isBarShort(d) ? 1 : -1
          const start = this.x(d.value) + paddingDirection * this.config.barLabelPadding

          return `translate(${start}, ${this.y.bandwidth()/2 + 4})`
        })
        .attr('text-anchor', d => isBarShort(d) ? 'start' : 'end')
        .text(d => this.styledNumber(d.value) + this.config.unit)
    },

    createSVG () {
      return d3.select('#' + this.svgId)
        .append('svg')
        .attr('class', 'd3-horizontal-bar-chart__svg')
        .attr('xmlns', 'http://www.w3.org/1999/xhtml')
        .attr('viewBox', '0 0 ' + this.config.width + ' ' + this.config.height)
        .attr('viewport', this.config.width + 'x' + this.config.height)
        .attr('preserveAspectRatio', 'xMidYMid')
        .attr('width', '100%')
        .attr('height', '100%')
    },

    styledNumber (number) {
      return number.toLocaleString()
    },

    wrap (text, width) {
      text.each(function () {
        const lineHeight = 1.1
        const text = d3.select(this)
        const words = text.text().split(/\s+/).reverse()
        const x = text.attr('x')
        
        const dy = 0 //prop?
        let line = []
        let lineNumber = 0

        let tspan = text.text(null)
          .append('tspan')
          .attr('x', x)
          .attr('y', 0)
          .attr('dy', dy + 'em')

        let word;

        while (word = words.pop()) {
          line.push(word)
          tspan.text(line.join(' '))

          if(tspan.node().getComputedTextLength() > width) {
            line.pop()
            tspan.text(line.join(' '))

            line = [word]
            tspan = text.append('tspan')
              .attr('x', x)
              .attr('y', 0)
              .attr('dy', ++lineNumber * lineHeight + dy + 'em')
              .text(word)
          }
        }
      })        
    }
  }
}
</script>

<style lang="scss">
@keyframes fullOpacity {
  to {
    opacity: 1;
  }
}
@keyframes fullScaleX {
  to {
    transform: scaleX(1);
  }
}

@keyframes fullScaleXY {
  to {
    transform: scale(1);
  }
}

.d3-horizontal-bar-chart {
  // hack to get the svg to scale in IE11
    // width: 100%;
    
    // position: relative;
  // end hack

  &-animate {
    .bar { animation: fullScaleX .8s forwards linear; }
    .bar-label { animation: fullOpacity .2s .8s forwards linear; }
  }

  &__svg { 
    // hack to get the svg to scale in IE11
      // display: block;
      // position: absolute;
      // top: 0;
      // left: 0;
    // end hack
  }

    .background { fill: rgba(lightblue, 0.4); }

    .bar {
      fill: rgba(0, 0, 0, .4);
      transform: scaleX(0);
    }

    .bar-label {
      fill: white;
      font-size: 14;
      opacity: 0;

      &--small-bar { fill: #666666; }
    }
}
</style>

