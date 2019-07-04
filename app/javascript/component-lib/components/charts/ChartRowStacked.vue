<template>
  <div class="chart--row-stacked">
    <h2
      v-if="title"
      class="chart__title"
    >
      {{ title }}
    </h2>

    <ul class="chart__chart ul-unstyled flex">
      <li
        v-for="row in rows"
        class="chart__bar flex flex-v-center"
        :class="themeClass"
        :style="{ width: row.percent + '%' }"
      >
        <span
          v-if="row.percent > 0"
          class="chart__percent"
        >{{ getValue(row) }}{{ units }}</span>
      </li>
    </ul>
    
    <chart-legend
      v-if="legend"
      :legend-items="legend"
      :theme="theme"
      class="chart__legend"
    />
  </div>
</template>

<script>
import ChartLegend from './ChartLegend'

export default {
  name: 'ChartRowStacked',

  components: { ChartLegend },

  props: {
    title: String,
    theme: String,
    rows: { // Row[]
      type: Array,
      required: true
    },
    legend: {
      type: Array
    },
    units: {
      type: String,
      default: '%'
    }
  },

  computed: {
    themeClass () {
      return `chart-theme--${this.theme}`
    }
  },

  methods: {
    getValue (row) {
      return row.value ? row.value : row.percent
    }
  }
}
</script>