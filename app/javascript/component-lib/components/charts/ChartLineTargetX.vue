<template>
  <g>
    <path
      :d="path"
      :stroke="style.colour"
      :stroke-width="style.strokeWidth"
      stroke-linecap="round"
      :stroke-dasharray="style.dashArray"
    />

    <text
      v-if="label"
      :x="x"
      dx="0.6em"
      y="5%"
      :font-size="fontSize"
      :font-weight="fontWeight"
    >
      <tspan
        v-for="(t, index) in label"
        :key="getLabelKey(index)"
        :x="x"
        dx="0.6em"
        dy="1.2em"
      >
        {{ t }}
      </tspan>
    </text>
  </g>
</template>

<script>
const DEFAULT_LINE_STYLE = {
  colour: '#000000',
  strokeWidth: '2',
  dashArray: '6 8'
}

export default {
  name: 'ChartLineTargetY',

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
    label: {
      type: String,
      default: ''
    },
    lineStyle: { //{colour: String, strokeWidth: string, dashArray: String}
      type: Object,
      default: () => {}
    },
    colour: {
      type: String,
      default: '#000000'
    },
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
      return `M ${this.x} ${this.minY} V ${this.maxY}`
    },

    style () {
      return {...DEFAULT_LINE_STYLE, ...this.lineStyle}
    }
  },

  methods: {
    getLabelKey (index) {
      return `chart-line-target-x-${this._uid}-label-${index}`
    }
  }
}
</script>