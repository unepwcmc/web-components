<template>
  <div class="chart--column chart flex flex-h-between">
    <div
      v-for="(column, index) in columns"
      :key="index"
      class="chart__column flex flex-column"
      :style="{ width: width }"
    >
      <span class="chart__percent flex-vs-center">{{ getColumnLabel(column, index) }}</span>
      <span
        class="chart__bar"
        :style="{ height: percent(column) + '%' }"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChartColumn',

  props: {
    title: {
      type: String,
      default: ''
    },
    columns: {
      type: Array,
      required: true
    },
    units: {
      type: String,
      default: '%'
    },
    optomiseColumnHeight: {
      type: Boolean,
      default: true
    } 
  },

  computed: {
    width () {
      const total = this.columns.length

      return (100/total) - 3 + '%'
    }
  },

  methods: {
    getColumnLabel (column, index) {
      return `${index+1}. ${column.value}${this.units}`
    },

    setMaxValue () {
      this.maxValue = Math.max.apply(Math, this.columns.map(col => col.value))
    },

    percent (column) {
      return this.maxValue ? 100 * column.value / this.maxValue : column.value
    }
  }
}
</script>