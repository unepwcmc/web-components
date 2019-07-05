<template>
  <ul class="chart--legend flex flex-wrap">
    <li
      v-for="(item, index) in legendItems"
      :key="`legend-item-${index}`"
      class="chart__legend-item flex flex-v-center"
      :class="themeClass"
    >
      <span
        :class="['chart__legend-key', {'chart__legend-key--line': isLine} ]"
        :style="style(item)"
      />
      <span class="chart__legend-text bold">{{ index + 1 }}.</span> 
      <span class="chart__legend-text">{{ item.title }}</span>
    </li>
  </ul>
</template>

<script>
export default {
  name: 'ChartLegend',

  props: {
    legendItems: { //{ title: String, colour: String }[]
      type: Array,
      required: true
    },
    isLine: {
      type: Boolean,
      default: false
    },
    theme: {
      type: String,
      default: 'default'
    }
  },

  computed: {
    themeClass () {
      return `theme--${this.theme}`
    }
  },

  methods: {
    style (item) {
      let styling = {}

      if(item.colour) {
        styling['background-color'] = item.colour

        if(item.colour == '#ffffff') { styling['border'] = 'solid 1px #cccccc' } 
      }

      return styling
    }
  }
}
</script>