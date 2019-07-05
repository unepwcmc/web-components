<template>
  <div
    class="nav__dropdown"
    :class="{'nav__dropdown--active': isActive}"
  >
    <button 
      :id="mixinTriggerId"
      aria-haspopup="true"
      :aria-expanded="isActive"
      :aria-controls="mixinModalId"
      class="nav__dropdown-toggle hover--pointer flex-inline flex-v-center"
      @click="toggleDropdown"
    >
      <label
        :for="mixinModalId"
        class="nav__select nav__select--dropdown"
      >{{ item.label }}</label>
      <span class="drop-arrow arrow-svg" />
    </button>
    <div class="nav__dropdown-wrapper">
      <menu
        :id="mixinModalId"
        class="nav__dropdown-menu"
        :class="{'nav__dropdown-menu--two-col': hasTwoColumns}"
      >
        <v-nav-link
          v-for="dropdownItem in item.children"
          :key="dropdownItem.id"
          class="nav__dropdown-item"
          :item="dropdownItem"
        />
      </menu>
    </div>
  </div>
</template>

<script>
import VNavLink from './VNavLink'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'

export default {
  components: {
    VNavLink
  },

  mixins: [
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeDropdown', openCallback: 'openDropdown'}),
    mixinPopupCloseListeners({closeCallback: 'closeDropdown'})
  ],

  props: {
    item: {
      required: true,
      type: Object
    },
    isBurger: {
      required: true,
      type: Boolean
    }
  },

  data() {
    return {
      isActive: false
    }
  },

  computed: {
    hasTwoColumns () {
      return !this.isBurger && this.item.children.length > 4
    },

    mixinModalId () {
      return `nav-dropdown-${this.item.id}`
    },

    mixinTriggerId () {
      return `nav-dropdown-toggle-${this.item.id}`
    }
  },

  methods: {
    closeDropdown () {
      this.isActive = false
    },
    openDropdown () {
      this.isActive = true
    },
    toggleDropdown (e) {
      this.isActive ? this.closeDropdown(e) : this.openDropdown(e)
    }
  }
}
</script>