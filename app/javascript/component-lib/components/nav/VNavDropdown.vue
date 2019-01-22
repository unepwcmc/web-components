<template>
  <div class="nav__dropdown" :class="{'nav__dropdown--active': isActive}">
    <button :id="mixinTriggerId" aria-haspopup="true" :aria-expanded="isActive" :aria-controls="mixinModalId" class="nav__dropdown-toggle hover--pointer flex-inline" @click="toggleDropdown">
      <label :for="mixinModalId" class="nav__select nav__select--dropdown">{{item.label}}</label>
      <span class="drop-arrow arrow-svg"></span>
    </button>
    <div class="nav__dropdown-wrapper">
      <menu :id="mixinModalId" class="nav__dropdown-menu" :class="{'nav__dropdown-menu--two-col': hasTwoColumns}">
        <v-nav-link
          class="nav__dropdown-item"
          v-for="dropdownItem in item.children"
          :item="dropdownItem"
          :key="dropdownItem.id"
        ></v-nav-link>
      </menu>
    </div>
  </div>
</template>

<script>
import VNavLink from "./VNavLink"
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'

export default {
  components: {
    VNavLink
  },

  mixins: [mixinFocusCapture('isActive'), mixinPopupCloseListeners('closeDropdown')],

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
      isActive: false,

      mixinModalId: `nav-dropdown-${this.item.label.toLowerCase()}`,
      mixinTriggerId: `nav-dropdown-toggle-${this.item.label.toLowerCase()}`
    }
  },

  methods: {
    closeDropdown () {
      this.isActive = false
    },
    openDropdown () {
      this.isActive = true
    },
    toggleDropdown () {
      this.isActive ? this.closeDropdown() : this.openDropdown()
    }
  },

  computed: {
    hasTwoColumns () {
      return !this.isBurger && this.item.children.length > 4
    }
  }
}
</script>