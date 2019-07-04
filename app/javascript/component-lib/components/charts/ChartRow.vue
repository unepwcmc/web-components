<template>
  <div class="chart--row">
    <h2
      v-if="title"
      class="chart__title"
    >
      {{ title }}
    </h2>

    <div class="chart__chart">
      <div
        v-for="row in rows"
        class="chart__row flex flex-v-center flex-h-between"
        :class="themeClass"
      >
        <span
          class="chart__bar"
          :style="{ width: row.percent + '%' }"
        /> 
        <span class="chart__percent">{{ getValue(row) }}{{ units }}</span>
        <span class="chart__label">{{ row.label }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChartRow',

  props: {
    title: String,
    theme: String,
    rows: { // Row[]
      type: Array,
      required: true
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