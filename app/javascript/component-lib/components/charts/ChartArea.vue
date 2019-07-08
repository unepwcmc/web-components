<template>
  <div class="chart__wrapper">
    <div class="chart--area">
      <div class="chart__chart flex">
        <div
          v-for="(dataset, index) in datasets"
          :key="`dataset-${index}`"
          class="chart__dataset"
          :style="style(dataset.percent)"
        >
          <div
            class="chart__bar"
            :class="['chart__bar-' + dataset.class]"
            :style="{ height: height + 'px' }"
          >
            <p class="chart__label no-margin">
              {{ dataset.title }} <span class="chart__label-percentage">{{ dataset.value }}{{ units }}</span>
            </p>
          </div>

          <div v-if="dataset.inner_square">
            <div
              class="chart__bar chart__bar-pa"
              :style="getInnerSquareSize(dataset.percent, dataset.inner_square.percent)"
            >
              <p class="chart__label-pa no-margin">
                {{ dataset.inner_square.title }} <span class="chart__label-percentage">{{ dataset.inner_square.value }}{{ units }}</span>
              </p>
            </div>
          </div>
        </div>
      </div>

      <chart-legend
        v-if="legend"
        :legend-items="legend"
      />
    </div>
  </div>
</template>

<script>
import ChartLegend from './ChartLegend'

export default {
  name: 'ChartArea',

  components: { ChartLegend },

  props: {
    datasets: { // {title: String, class: String, value: Number, percent: Number, innerSquare: {title: String, value: Number, percent: Number}}
      type: Array,
      required: true
    },
    height: {
      type: Number,
      default: 180
    },
    id: {
      type: String,
      required: true
    },
    units: {
      type: String,
      default: '%'
    },
    legend: {
      type: Array, // Legend
      default: () => []
    }
  },

  data () {
    return {
      chartWidth: 0
    }
  },

  mounted () {
    this.chartWidth = this.$el.clientWidth
    window.addEventListener('resize', () => {
      this.chartWidth = this.$el.clientWidth
    })
  },

  methods: {
    style (percent) {
      return `width: ${percent}%`
    },

    getInnerSquareSize (parentPercent, innerPercent) {
      const parentArea = this.chartWidth * this.height * (parentPercent/100)
      const innerArea = parentArea * (innerPercent/100)
      const innerAreaLength = Math.round(Math.sqrt(innerArea))

      return { width: `${innerAreaLength}px`, height: `${innerAreaLength}px` }
    }
  },
}
</script>