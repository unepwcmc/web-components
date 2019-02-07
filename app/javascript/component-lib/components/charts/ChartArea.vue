<template>
<div class="chart__wrapper">
  <div class="chart--area">
    <div class="chart__chart flex">
      <div v-for="dataset in datasets" class="chart__dataset" :style="style(dataset.cssPercent)">
        <div class="chart__bar" :class="['chart__bar-' + dataset.class]" :style="{ height: height + 'px' }">
          <p class="chart__label no-margin">{{ dataset.title }} <span class="chart__label-percentage">{{dataset.percent }}%</span></p>
        </div>

        <div v-if="dataset.protected_areas">
          <div class="chart__bar chart__bar-pa" :style="getPaSize(dataset.cssPercent, dataset.protected_areas.percent)">
            <p class="chart__label-pa no-margin">{{ dataset.protected_areas.title }} <span class="chart__label-percentage">{{dataset.protected_areas.percent }}%</span></p>
          </div>
        </div>
      </div>
    </div>

    <chart-legend v-if="legend" :rows="legend"></chart-legend>
  </div>
</div>
</template>

<script>
  import ChartLegend from './ChartLegend'

  export default {
    name: 'chart-area',

    components: { ChartLegend },

    props: {
      datasets: {
        type: Array,
        required: true
      },
      id: {
        type: String,
        required: true
      },
      legend: Array,
    },

    data () {
      return {
        height: 180,
        chartWidth: 0
      }
    },

    mounted () {
      this.chartWidth = this.$el.clientWidth
    },

    methods: {
      style (percent) {
        return `width: ${percent}%`
      },

      getPaSize (parentPercent, paPercent) {
        const parentArea = this.chartWidth * this.height * (parentPercent/100),
          paArea = parentArea * (paPercent/100),
          paAreaLength = Math.round(Math.sqrt(paArea))

        return { width: `${paAreaLength}px`, height: `${paAreaLength}px` }
      }
    }
  }
</script>

<style lang="scss">
.chart {
//--------------------------------------------------
// area chart
//--------------------------------------------------
  &--area {
    margin-bottom: 20px;

    .chart {
      &__chart {}

        &__dataset {
          position: relative;

          &:first-child { 
            .chart__bar { 
              border-top-left-radius: 2px; 
              border-bottom-left-radius: 2px; 
            }
          }

          &:last-child { 
            .chart__bar { 
              border-top-right-radius: 2px; 
              border-bottom-right-radius: 2px; 
            }
          }
        }

          &__bar {
            position: relative;
        
            &-abnj { 
              background-color: grey; 
              border-right: solid white 1px;
            }

            &-eez { 
              background-color: blue; 
              border-right: solid white 1px;
            }

            &-land { background-color: green; }

            &-marine { 
              background-color: lightblue; 
              border-right: solid white 1px;
            }

            &-pa { 
              background-color: navy; 

              position: absolute;
              top: 8px;
              left: 8px;

              // @include breakpoint($small) {
              //   top: 20px;
              //   left: 20px;
              // }
            }
          }

          &__label {
            position: absolute;
            bottom: 2px;
            left: 8px;
            

            // @include breakpoint($small) {
            //   font-size: 16px;
              
            //   bottom: 10px;
            //   left: 50%;

            //   transform: translateX(-50%);
            // }
          }
            &__label-pa {
              // font-size: 12px;
              // font-weight: light;
              white-space: nowrap;

              position: absolute;
              top: calc(100% + 4px);
              left: 0;

              // @include breakpoint($small) {
              //   font-size: 16px;

              //   top: 0;
              //   left: calc(100% + 10px);
              // }
            }

      &__legend-item {
        &:first-child {
          .chart__legend-key { background-color: navy; }
        }
      }
    }
  }
}
</style>
