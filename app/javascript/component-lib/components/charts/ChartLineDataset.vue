<template>
  <g> 
    <path 
      :d="path" 
      fill="none" 
      :stroke="colour.line" 
      stroke-width="6"
    />

    <circle
      :cx="middle.x"
      :cy="middle.y"
      :fill="colour.line"
      r="18"
    >
      {{ index + 1 }}
    </circle>
    <text
      :x="middle.x"
      :y="middle.y"
      :fill="colour.text"
      text-anchor="middle"
      dominant-baseline="middle"
      :font-size="fontSize"
      :font-weight="fontWeight"
    >
      {{ index + 1 }}
    </text>
  </g>
</template>

<script>
export default {
  name: 'ChartLineDataset',

  props: {
    path: {
      type: String,
      required: true
    },
    index: {
      type: Number,
      required: true
    },
    colour: {
      type: Object,
      required: true
    },
    middle: {
      type: Object,
      required: true
    },
    fontSize : {
      type: Number,
      default: 18
    },
    fontWeight : {
      type: Number,
      default: 900
    }
  }
}
</script>