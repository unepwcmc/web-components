<template>
  <div class="sticky-bar">
    <slot></slot>
  </div>  
</template>

<script>
  import ScrollMagic from 'scrollmagic'

  export default {
    name: 'sticky-bar',

    mounted () {
      this.scrollMagicHandlers()
    },

    methods: {
      scrollMagicHandlers () {
        let scrollMagicSticky = new ScrollMagic.Controller()

        new ScrollMagic.Scene({ triggerElement: '.sm-trigger-sticky', reverse: true })
          .triggerHook('onLeave')
          .setClassToggle('.sm-target-sticky', 'sticky-bar--stuck')
          .addTo(scrollMagicSticky)
      }
    }
  }
</script>

<style lang="scss">
@keyframes showNav {
  from {
    transform: translateY(-100%);
  }
  to {
    transform: translateY(0);
  }
}

// @keyframes unstickNav {
//   from {
//     transform: translateY(100%);
//   }
//   to {
//     transform: translateY(0);
//   }
// }

.sm-target-sticky {
  background-color: lightgrey;
}

.sticky-bar {
  width: 100%;

  display: block;
  position: absolute;
  top: 100px;
  left: 0;

  // &--unstuck {
  //   animation: unstickNav .25s forwards linear;
  // }

  &--stuck {    
    display: block;
    position: fixed;
    top: 0;
    right: 0;
    left: 0;

    animation: showNav .25s forwards linear;
  }
}
</style>
