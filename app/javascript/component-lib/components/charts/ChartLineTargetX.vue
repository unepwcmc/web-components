<template>
  <g>
    <path :d="path" :stroke="style.colour" :stroke-width="style.strokeWidth" stroke-linecap="round" :stroke-dasharray="style.dashArray" />

    <text v-if="label" :x="x + 10" :y="`50%`" :font-size="fontSize" :font-weight="fontWeight">
      <tspan v-for="t in label" :x="x + 10" :dy="24">{{ t }}</tspan>
    </text>
  </g>
</template>

<script>
const DEFAULT_LINE_STYLE = {
  colour: '#000000',
  strokeWidth: '4',
  dashArray: ''
}

export default {
  name: 'chart-line-target-y',

  props: {
    minY: {
      type: Number,
      required: true
    },
    maxY: {
      type: Number,
      required: true
    },
    x: {
      type: Number,
      required: true
    },
    lineStyle: {
      type: Object,
      default: () => {}
    },
    label: Array,
    colour: {
      type: String,
      default: '#000000'
    },
    fontSize: {
      type: String,
      default: 'inherit'
    },
    fontWeight: {
      type: String,
      default: 'inherit'
    },
  },

  computed: {
    path () {
      return `M ${this.x} ${this.minY} V ${this.maxY}`
    },

    style () {
      return {...DEFAULT_LINE_STYLE, ...this.lineStyle}
    }
  }
}
</script>