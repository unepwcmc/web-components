<template>
  <ul class="chart--legend ul-unstyled flex flex-wrap">
    <li v-for="row, index in rows" class="chart__legend-item flex flex-v-center" :class="themeClass">
      <span v-if="row.line" class="chart__legend-key" :style="lineStyle"></span>
      <span v-else class="chart__legend-key" :style="style(row)"></span>
      <span class="chart__legend-text bold">{{ index + 1 }}.</span> 
      <span class="chart__legend-text">{{ row.title }}</span>
    </li>
  </ul>
</template>

<script>
  export default {
    name: 'chart-legend',

    props: {
      rows: { //{ line: Line, title: String, colour: Colour }[]
        type: Array,
        required: true
      },
      theme: String
    },

    data () {
      return {
        lineStyle: {
          'border-top': 'dashed 1px #871313',
          'background-color': 'transparent',
          'height': 0
        }
      }
    },

    computed: {
      themeClass () {
        return `theme--${this.theme}`
      }
    },

    methods: {
      style (row) {
        let styling = {}

        if(row.colour) {
          styling['background-color'] = row.colour

          if(row.colour == '#ffffff') { styling['border'] = 'solid 1px #cccccc' } 
        }

        return styling
      }
    }
  }
</script>