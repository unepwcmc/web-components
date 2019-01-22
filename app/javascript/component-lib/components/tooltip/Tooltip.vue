<template>
  <div class="tooltip">
    <div
      tabindex="0"
      :aria-describedby="id"
      :aria-expanded="isActive"
      @mouseenter="toggleTooltip(true)"
      @mouseleave="toggleTooltip(false)"
      v-touch="toggleTooltip"
      class="tooltip__trigger">
      <slot></slot>
    </div>
    <div role="tooltip" :id="id" v-show="isActive" class="tooltip__target">{{ text }}</div>
  </div>
</template>

<script>
  export default {
    name: 'tooltip',

    props: {
      text: {
        type: String,
        required: true
      }
    },

    data () {
      return {
        isActive: false,
        id: this._uid
      }
    },

    methods: {
      toggleTooltip (boolean) {
        this.isActive = typeof boolean == 'boolean' ? boolean : !this.isActive
      }
    },

    mounted () {      
      const tooltipTrigger = this.$el.querySelector('.tooltip__trigger')

      tooltipTrigger.addEventListener('blur', () => {
        this.toggleTooltip(false)
      })
      tooltipTrigger.addEventListener('focus', () => {
        this.toggleTooltip(true)
      })
    }
  }  
</script>

<style lang="scss">
$tooltip-background-color: grey;

.tooltip {
  position: relative;

  &__trigger {
    cursor: pointer;
  }

  &__target {
    background-color: $tooltip-background-color;

    position: absolute;
    top: 145%;
    left: 50%;
    z-index: 1;

    transform: translateX(-50%);

    &:after {
      border-bottom: solid 10px $tooltip-background-color;
      border-right: solid 10px transparent;
      border-left: solid 10px transparent;
      content: '';
      width: 0; height: 0;

      position: absolute;
      top: -10px;
      left: 50%;

      transform: translateX(-50%);
    }
  }
}
</style>

