<template>
  <div class="chart--column">
    <div class="chart__chart flex flex-h-between">
      <div v-for="column, index in columns" class="chart__column flex flex-column flex-h-end" :style="{ width: width }">
        <span class="chart__percent flex-vs-center">{{ column.value + units }}</span>
        <span class="chart__bar" :style="{ height: percent(column) + '%' }"></span> 

        <p class="chart__label">
          <span class="chart__label-index">{{ index + 1 }}.</span>
          <span class="bold">{{ column.label }}</span>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'chart-column',

    props: {
      title: String,
      columns: {
        type: Array,
        required: true
      },
      units: String
    },

    methods: {
      percent (column) {
        return this.maxValue ? 100 * column.value / this.maxValue : column.value
      }
    },

    computed: {
      width () {
        const total = this.columns.length
        return (100/total) - 3 + '%'
      }
    }
  }
</script>