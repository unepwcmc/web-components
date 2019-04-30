<template>
  <div class="v-select v-select--search relative" :class="{'v-select--disabled': isDisabled}">
    <input type="hidden" :name="config.id" :id="config.id" v-model="selectedInternal.name" />

    <div v-if="config.label" class="v-select__label">
      <label :for="toggleId" class="v-select__selection">{{ config.label }}</label>
      <slot name="label-icon"></slot>
    </div>

    <div :class="['v-select__search relative', {'v-select__search--active': isActive}]">
      <label class="screen-reader" for="v-select-search">{{ config.label }} search</label>
      <input
        id="v-select-search"
        :class="['v-select__search-input', hasSelectedClass]"
        type="text"
        role="combobox"
        aria-haspopup="listbox"
        aria-autocomplete="list"
        :aria-expanded="showOptions"
        :aria-owns="dropdownId"
        :aria-activedescendant="highlightedOptionId"
        v-model="searchTerm" 
        :placeholder="placeholder"
        :disabled="isDisabled"
        @focus="openSelect">

      <span class="v-select__search-icons">
        <span class="v-select__search-icon" v-show="!showResetIcon"></span>
        <button 
          id="v-select-search-reset"
          class="v-select__search-icon v-select__search-icon--reset hover--pointer"
          v-show="showResetIcon"
          @click="resetSearchTerm"></button>
        <span 
          class="drop-arrow drop-arrow--margin-right arrow-svg hover--pointer"
          @click="toggleSelect"></span>
      </span>
    </div>

    <ul 
      v-show="showOptions" 
      :id="dropdownId" 
      role="listbox" 
      class="v-select__dropdown ul--unstyled">

      <li
        v-for="(option, index) in filteredOptions"
        :class="['v-select__option hover--pointer', {'v-select__option--selected': isSelected(option), 'v-select__option--highlighted': isHighlighted(index)}]"
        role="option"
        :aria-selected="isHighlighted(index)"
        :id="getOptionInputId(option)"
        :key="option.id"
        v-show="matchesSearchTerm(option)"
        @click="selectOption(option)">
        {{ option.name }}
      </li>

    </ul> 

  </div>
</template>

<script>
//TODO: exttract option classes
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import { isTabForward, isTabBackward, getRadioToFocus } from '../../helpers/focus-helpers'
import { KEYCODES } from '../../helpers/keyboard-helpers'
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
      highlightedOptionIndex: 0,
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

    filteredOptions () {
      return this.options.filter(option => this.matchesSearchTerm(option))
    },

    highlightedOptionId () {
      if (this.isActive && this.filteredOptions.length) {
        return this.getOptionInputId(this.filteredOptions[this.highlightedOptionIndex])
      }
      
      return null
    },

    showOptions () {
      return this.isActive && Boolean(this.filteredOptions.length)
    },

    placeholder () {
      return this.selectedInternal.id === UNDEFINED_ID ? DEFAULT_SELECT_MESSAGE : this.selectedInternal.name
    },

    showResetIcon () {
      return this.searchTerm && this.isActive
    },

    hasSelectedClass () {
      return {
        'v-select__search-input--has-selected': this.selectedInternal.id !== UNDEFINED_ID
      }
    }
  },

  watch: {
    searchTerm () {
      this.highlightedOptionIndex = 0
    },

    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption
    },

    selectedInternal (newSelectedInternal) {
      this.$emit('update:selected-option', newSelectedInternal)
    }
  },

  created () {
    this.initializeSelectedInternal()
  },

  mounted () {
    this.addTabFromSearchListener()
    this.addArrowKeyListeners()
    this.addTabForwardFromResetListener()
  },

  methods: {
    closeSelect () {
      this.searchTerm = ''
      this.highlightedOptionIndex = 0
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

    selectOption (option) {
      this.selectedInternal = option
      this.closeSelect()
      document.activeElement.blur()
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

    isHighlighted (index) {
      return index === this.highlightedOptionIndex
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
    
    addTabFromSearchListener () {
      this.$el.querySelector('#v-select-search').addEventListener('keydown', e => {
        if (isTabBackward(e)) {
          this.closeSelect()
        } else if (isTabForward(e) && !this.showResetIcon) {
          this.closeSelect()
        }
      })
    },

    addTabForwardFromResetListener () {
      this.$el.querySelector('#v-select-search-reset').addEventListener('keydown', e => {
        if (isTabForward(e)) {
          this.closeSelect()
        }
      })
    },

    addArrowKeyListeners () {
      this.$el.querySelector('#v-select-search').addEventListener('keydown', e => {
        switch (e.keyCode) {
          case KEYCODES.down:
            this.incremementKeyboardFocus()
            break;
          case KEYCODES.up:
            this.decrementKeyboardFocus()
            break;
          case KEYCODES.enter:
            if(this.filteredOptions.length) { this.selectOption(this.filteredOptions[this.highlightedOptionIndex]) }
            break;
          case KEYCODES.esc:
            document.activeElement.blur()
            break;
        }
      })
    },

    incremementKeyboardFocus () {
      if (this.highlightedOptionIndex === this.filteredOptions.length - 1) {
        this.highlightedOptionIndex = 0
      } else {
        this.highlightedOptionIndex++
      }
    },

    decrementKeyboardFocus () {
      if (this.highlightedOptionIndex === 0) {
        this.highlightedOptionIndex = this.filteredOptions.length - 1
      } else {
        this.highlightedOptionIndex--
      }
    }
  }
}
</script>