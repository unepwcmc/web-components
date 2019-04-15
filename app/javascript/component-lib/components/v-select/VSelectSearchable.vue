<template>
  <div class="v-select relative" :class="{'v-select--disabled': isDisabled}">
    <input type="hidden" :name="config.id" :id="config.id" v-model="selectedInternal.name" />

    <div v-if="config.label" class="v-select__label">
      <label :for="toggleId" class="v-select__selection">{{ config.label }}</label>
      <slot name="label-icon"></slot>
    </div>

    <div :class="['v-select__search relative', {'v-select__search--active': isActive}]">
      <input
        id="v-select-search"
        class="v-select__search-input"
        type="text" 
        v-model="searchTerm" 
        :placeholder="selectionMessage"
        aria-haspopup="true"
        :aria-controls="dropdownId"
        :disabled="isDisabled"
        @focus="openSelect">
      <span class="v-select__search-icon flex-no-shrink" v-show="!searchTerm"></span>
      <button id="v-select-search-reset" class="v-select__search-icon v-select__search-icon--reset hover--pointer flex-no-shrink" v-show="searchTerm" @click="resetSearchTerm"></button>
      <span @click="toggleSelect" class="drop-arrow arrow-svg hover--pointer flex-no-shrink"></span>
    </div>

    <ul 
      v-show="isActive" 
      :id="dropdownId" 
      role="radiogroup" 
      class="v-select__dropdown ul--unstyled">

      <li
        class="v-select__option"
        v-for="option in options"
        :key="option.id"
        v-show="matchesSearchTerm(option)">
        <label class="v-select__option-label" :for="getOptionInputId(option)">
          <input
            class="v-select__default-radio"
            type="radio"
            :id="getOptionInputId(option)"
            :name="dropdownOptionsName"
            :value="option"
            v-model="selectedInternal">
          <span class="v-select__radio flex-no-shrink"></span>
          <span>{{ option.name }}</span>
        </label>
      </li>

    </ul> 

  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import { isTabForward, isTabBackward, getRadioToFocus } from '../../helpers/focus-helpers'
const UNDEFINED_ID = '__UNDEFINED__';
const UNDEFINED_OBJECT = { id: UNDEFINED_ID, name: 'None' }
const DEFAULT_SELECT_MESSAGE = 'Select option'

export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect'})
  ],

  props: {
      config: {
        required: true,
        type: Object
      },
      options: {
        default: () => [],
        type: Array
      },
      selected: {
        default: null,
      }
  },

  data () {
    return {
      isActive: false,
      selectedInternal: null,
      searchTerm: '',
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id
    }
  },

  computed: {
    isDisabled () {
      return !this.options.length
    },

    selectionMessage () {
      return this.selectedInternal.id === UNDEFINED_ID ? DEFAULT_SELECT_MESSAGE : this.selectedInternal.name
    }
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption
    },

    selectedInternal (newSelectedInternal) {
      this.$emit('update:selected-option', newSelectedInternal)
    },

    options () {
      this.addTabListenerToRadios()
    }
  },

  created () {
    this.initializeSelectedInternal()
  },

  mounted () {
    this.addTabBackFromSearchListener()
    this.addTabListenerToRadios()
    this.addTabIntoRadioGroupListener()
  },

  methods: {
    closeSelect () {
      this.searchTerm = ''
      this.isActive = false
    },

    openSelect () {
      this.isActive = true
    },

    toggleSelect (e) {
      if (this.options.length && !this.isActive) {
        this.openSelect(e)
      } else {
        this.closeSelect(e)
      }
    },

    initializeSelectedInternal () {
      if (this.selected === null) {
        this.selectedInternal = UNDEFINED_OBJECT
      } else {
        this.selectedInternal = this.selected
      }
    },

    isSelected (option) {
      return option.id === this.selectedInternal.id
    },

    getOptionInputId (option) {
      return `option-${this.config.id}-${option.id}`
    },

    matchesSearchTerm (option) {
      const regex = new RegExp(`${this.searchTerm}`, 'i')
      const match = option.name.match(regex)

      return !Boolean(this.searchTerm) || match
    },

    resetSearchTerm () {
      this.$el.querySelector('#v-select-search').focus()
      this.searchTerm = ''
    },

    addTabListenerToRadios () {
      Array.prototype.forEach.call(this.$el.querySelectorAll('.v-select__default-radio'), input => {
        input.addEventListener('keydown', e => {
          if (isTabForward(e)) {
            this.closeSelect()
          }
        })
      })
    },

    addTabIntoRadioGroupListener () {
      this.$el.querySelector('#v-select-search-reset').addEventListener('keydown', e => {
        if (isTabForward(e)) {
          e.preventDefault()

          const optionEls = this.$el.querySelectorAll('.v-select__option')
          const radioToFocus = getRadioToFocus(optionEls)

          if (radioToFocus) {
            radioToFocus.focus()
          } else {
            this.closeSelect()
            document.activeElement.blur()
          }
        }
      })
    },
    
    addTabBackFromSearchListener () {
      this.$el.querySelector('#v-select-search').addEventListener('keydown', e => {
        if (isTabBackward(e)) {
          this.closeSelect()
        }
      })
    }
  }
}
</script>