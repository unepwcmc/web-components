<template>
<div class="flex flex-wrap">
  <div class="flex-2-fiths">
    <div class="d3-sunburst-wrapper">
      <div class="d3-sunburst u-text-sans" :style="{ paddingTop: '100%' }"></div>
    </div>
  </div>
  
  <div class="flex-3-fiths d3-sunburst__info-wrapper">
    <div class="d3-sunburst__info" :class="{ 'd3-sunburst__info--active' : isActive }">
      <p class="d3-sunburst__title">{{ name }}</p>
      <p v-for="item in breakdown">
        <span class="d3-sunburst__subtitle">{{ item.name }}</span>
        <span>{{ styledNumber(item.size) }}km</span>
      </p>
    </div>
  </div>
</div>
</template>

<script>
import * as d3 from 'd3'
import ScrollMagic from 'scrollmagic'

const DEFAULT_CONFIG = {
  fractionalStrokeWidth: 0.01
}

export default {
  name: 'sunburst',

  props: { 
    data: Object, //{ name: String, children: {name: String, size: Number, breakdown: {name: String, size: Number}[]} }
    propsConfig: Object // {fractionalStrokeWidth: Number}
  },

  data () {
    return {
      width: 1,
      radius: 0,
      totalSize: 0,
      svg: '',
      chart: '',
      name: '',
      breakdown: [],
      isActive: false,
      config: {}
    }
  },

  created () {
    this.config = {...DEFAULT_CONFIG, ...this.propsConfig}
    this.radius = this.width / 2
  },

  mounted () {
    this.renderChart()

    //trigger mouse enter on the first pie section so that the info panel is populated
    const firstSection = '#' + (this.data.children[0].name).replace(/\s|\./g, '-')
    d3.select(firstSection).dispatch('mouseover')
  },

  methods: {
    renderChart () {
      // size constiables
      
      const totalItems = this.data.children.length
      const color = d3.scaleSequential(d3.interpolate('#efefef', '#787878')).domain([0, totalItems])
      const data = d3.hierarchy(this.data).sum(d => d.size )

      // functions
      const partition = this.partition()
      const arc = this.arc()

      // create svg elements
      this.svg = this.createSVG()
      this.chart = this.createChart()

      // data
      const nodes = partition(data).descendants()

      // build chart
      const path = this.chart.datum(data).selectAll('path')
        .data(nodes)
        .enter().append('path')
        .attr('id', d => (d.data.name).replace(/\s|\./g, '-') )
        .attr('class', 'd3-sunburst__section')
        .attr('display', d => d.depth ? null : 'none' ) // hide inner ring
        .attr('d', d => arc(d) )
        .style('stroke', '#fff')
        .style('stroke-width', this.config.fractionalStrokeWidth * this.width)
        .style('fill', (d, i) => color(i) )
        .on('mouseover', this.mouseover)

      this.totalSize = path.datum().value
    },

    createSVG () {
      return d3.select('.d3-sunburst')
        .append('svg')
        .attr('class', 'd3-sunburst__svg')
        .attr('xmlns', 'http://www.w3.org/1999/xhtml')
        .attr('viewBox', '0 0 ' + this.width + ' ' + this.width)
        .attr('viewport', this.width + 'x' + this.width)
        .attr('preserveAspectRatio', 'xMidYMid')
        .attr('width', '100%')
        .attr('height', '100%')
    },

    createChart (svg) {
      return this.svg.append('g').attr('transform', 'translate(' + this.width / 2 + ',' + this.width / 2 + ')')
    },

    partition () {
      return d3.partition().size([2 * Math.PI, this.radius * this.radius])
    },

    arc () {
      return d3.arc()
        .startAngle(d => d.x0 )
        .endAngle(d => d.x1 )
        .innerRadius(d => Math.sqrt(d.y0) * 3/4 )
        .outerRadius(d => Math.sqrt(d.y1) )
    },

    mouseover (d) {
      this.resetSections()

      this.name = d.data.name
      this.breakdown = d.data.breakdown

      const sequenceArray = d.ancestors().reverse()
      sequenceArray.shift() // remove root node from the array

      // highlight only those that are an ancestor of the current segment.
      this.chart.selectAll('path')
        .filter(node => sequenceArray.indexOf(node) >= 0)
        .style('fill', '#A1D8DE')

      this.isActive = true
    },

    resetSections () {
      const totalItems = this.data.children.length
      const color = d3.scaleSequential(d3.interpolate('#ffffff', '#898989')).domain([0, totalItems])

      this.chart.selectAll('path').style('opacity', 1)
      this.chart.selectAll('path').style('fill', (d, i) => color(i) )
    },

    styledNumber (number) {
      return number.toLocaleString()
    }
  }
}
</script>

<style lang="scss">
.d3-sunburst {
  position: relative;

  &-wrapper { 
    width: 60%; 

    // @include breakpoint($medium){ 
    //   margin: 0 auto;
    //   width: 100%; 
    // }
  }

  &__svg {
    // hack to get the svg to scale in IE11
    display: block;
    position: absolute;
    top: 0;
    left: 0;
    // end hack
  }

  &__info-wrapper {
    display: flex;

    align-items: center;
  }

    &__info {
      display: none;

      // @include breakpoint($medium){ 
      //   margin: 0 0 0 (14);
      //   text-align: left; 
      // }

      // @include breakpoint($large){ margin-left: (22); }

      &--active { display: block; }
    }

      &__title {
        // @include breakpoint($large){ font-size: (28); }
      }

      &__subtitle {
        display: block;
        // @include breakpoint($large){ font-size: (20); }
      }
}
</style>
