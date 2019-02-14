<template>
  <g>
    <text v-if="label" :x="minX" :y="y" dy="-0.6em" :font-size="fontSize" :font-weight="fontWeight">{{ label }}</text>
    <path :d="path" :stroke="style.colour" :stroke-width="style.strokeWidth" stroke-linecap="round" :stroke-dasharray="style.dashArray" />
  </g>
</template>

<script>
const DEFAULT_LINE_STYLE = {
  colour: '#000000',
  strokeWidth: '2',
  dashArray: '6 8'
}

export default {
  name: 'chart-line-target-x',

  props: {
    minX: {
      type: Number,
      required: true
    },
    maxX: {
      type: Number,
      required: true
    },
    y: {
      type: Number,
      required: true
    },
    label: String,
    lineStyle: Object,
    fontSize: {
      type: Number,
      default: 14
    },
    fontWeight: {
      type: String,
      default: 'inherit'
    },
  },

  computed: {
    path () {
      return `M ${this.minX} ${this.y} H ${this.maxX}`
    },

    style () {
      return {...DEFAULT_LINE_STYLE, ...this.lineStyle}
    }
  }
}
</script>