<template>
  <nav aria-label="site-nav" class="nav flex flex-v-center flex-h-between">
    <a href="" title="Home" class="nav__logo">Home</a>

    <span class="nav__left flex-hs-start">
      <slot name="nav-left"></slot>
    </span>

    <div class="nav__item-container flex flex-v-center flex-h-end" :class="navType">

      <button id="close-nav-pane" class="nav__close" v-show="isBurgerNav" @click="closeNavPane">X</button>
      <ul role="menubar" class="ul--unstyled">
        <li role="none" class="nav__item" v-for="page in pages" :key="page.id">
          <v-nav-dropdown
            v-if="page.children"
            :item="page"
            :is-burger="isBurgerNav">
          </v-nav-dropdown>
          <v-nav-link v-else :item="page"></v-nav-link>
        </li>
      </ul>

    </div>

    <span class="nav__right">
      <slot name="nav-right"></slot>
    </span>

    <button id="open-nav-pane" class="nav__burger" v-show="isBurgerNav" @click="openNavPane">=</button>

  </nav>
</template>

<script>
import VNavDropdown from "./VNavDropdown.vue"
import VNavLink from "./VNavLink"
import { mixinResponsive } from "../../mixins/mixin-responsive"

export default {
  components: {
    VNavDropdown,
    VNavLink
  },

  mixins: [mixinResponsive],

  props: {
    pages: {
      required: true,
      type: Array
    },
    isAlwaysBurger: {
      default: false,
      type: Boolean
    }
  },

  data () {
    return {
      isNavPaneActive: false,
      selectedDropdownId: null
    }
  },

  methods: {
    openNavPane() {
      this.isNavPaneActive = true
    },
    
    closeNavPane() {
      this.isNavPaneActive = false
    }
  },

  computed: {
    isBurgerNav() {
      return this.isAlwaysBurger || !this.isLarge()
    },

    navType() {
      return { 
        'nav--pane': this.isBurgerNav,
        'nav--bar': !this.isBurgerNav,
        'nav-pane--active': this.isNavPaneActive
      }
    }
  }
}
</script>

<style lang="scss">
$black: #000000;
$white: #ffffff;

.nav {
  &__close {
    position: absolute;
    top: 0;
    right: 0;
    z-index: 1;
  }

  .drop-arrow {
    transform: rotate(0deg) scale(0.8);
  }
  
  &__dropdown--active {
    .drop-arrow { transform: rotate(180deg) scale(0.8); }
    .nav__dropdown-menu { display: block; }
  }

    &__dropdown-menu { display: none; }

//--------------------------------------------------
// burger nav
//--------------------------------------------------
  &--pane {
    background-color: $black;
    color: $white;
    width: 100%;
        
    display: block;
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    z-index: 2000;

    transform: translateX(100%);

    transition: transform 0.4s ease-in-out;

    &.nav-pane--active {
      transform: translateX(0);
    }
  }
}
</style>
