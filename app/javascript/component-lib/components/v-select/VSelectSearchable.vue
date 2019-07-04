<template>
  <div
    class="v-select v-select--search relative"
    :class="{'v-select--disabled': isDisabled}"
  >
    <input
      :id="config.id"
      v-model="selectedInternal.name"
      type="hidden"
      :name="config.id"
    >

    <div
      v-if="config.label"
      class="v-select__label"
    >
      <label
        :for="toggleId"
        class="v-select__selection"
      >{{ config.label }}</label>
      <slot name="label-icon" />
    </div>

    <div :class="['v-select__search relative', {'v-select__search--active': isActive}]">
      <label
        class="screen-reader"
        for="v-select-search"
      >{{ config.label }} search</label>
      <input
        id="v-select-search"
        v-model="searchTerm"
        class="v-select__search-input"
        type="text"
        role="combobox"
        aria-haspopup="listbox"
        aria-autocomplete="list"
        :aria-expanded="showOptions"
        :aria-owns="dropdownId"
        :aria-activedescendant="highlightedOptionId" 
        :placeholder="placeholder"
        :disabled="isDisabled"
        @focus="openSelect"
      >

      <span class="v-select__search-icons">
        <span
          v-show="!showResetIcon"
          class="v-select__search-icon"
        />
        <button 
          v-show="showResetIcon"
          id="v-select-search-reset"
          class="v-select__search-icon v-select__search-icon--reset hover--pointer"
          @click="resetSearchTerm"
        />
        <span 
          class="drop-arrow drop-arrow--margin-right arrow-svg hover--pointer"
          @click="toggleSelect"
        />
      </span>
    </div>

    <ul 
      v-show="showOptions" 
      :id="dropdownId" 
      role="listbox" 
      class="v-select__dropdown ul--unstyled"
    >
      <li
        v-for="(option, index) in filteredOptions"
        v-show="matchesSearchTerm(option)"
        :id="getOptionInputId(option)"
        :key="option.id"
        :class="['v-select__option hover--pointer', conditionalOptionClasses(option, index)]"
        role="option"
        :aria-selected="isHighlighted(index)"
        @click="selectOption(option)"
      >
        {{ option.name }}
      </li>
    </ul>
  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import { isTabForward, isTabBackward, getRadioToFocus } from '../../helpers/focus-helpers'
import { KEYCODES } from '../../helpers/keyboard-helpers'
const UNDEFINED_ID = '__UNDEFINED__'
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
      highlightedOptionIndex: -1,
      searchTerm: '',
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id
    }
  },

  computed: {
    filteredOptions () {
      return this.options.filter(option => this.matchesSearchTerm(option))
    },

    hasKeyboardFocus () {
      return this.highlightedOptionIndex >= 0
    },

    highlightedOptionId () {
      if (this.isActive && this.filteredOptions.length && this.hasKeyboardFocus) {
        return this.getOptionInputId(this.filteredOptions[this.highlightedOptionIndex])
      }

      return null
    },

    isDisabled () {
      return !this.options.length
    },

    placeholder () {
      return DEFAULT_SELECT_MESSAGE
    },

    showOptions () {
      return this.isActive && Boolean(this.filteredOptions.length)
    },

    showResetIcon () {
      return this.searchTerm && this.isActive
    }
  },

  watch: {
    searchTerm () {
      this.resetHighlightedIndex()
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
      this.setSearchTermToSelected()
      this.resetHighlightedIndex()
      this.isActive = false
    },

    openSelect () {
      this.searchTerm = ''
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
        this.setSearchTermToSelected()
      }
    },

    isSelected (option) {
      return option.id === this.selectedInternal.id
    },

    selectOption (option) {
      this.selectedInternal = option
      this.closeSelect()
      document.activeElement.blur()
    },

    isHighlighted (index) {
      return index === this.highlightedOptionIndex
    },

    resetHighlightedIndex() {
      this.highlightedOptionIndex = -1
    },

    getOptionInputId (option) {
      return `option-${this.config.id}-${option.id}`
    },

    conditionalOptionClasses (option, index) {
      return {
        'v-select__option--selected': this.isSelected(option),
        'v-select__option--highlighted': this.isHighlighted(index)
      }
    },

    matchesSearchTerm (option) {
      const regex = new RegExp(`${this.searchTerm}`, 'i')
      const match = option.name.match(regex)

      return !this.searchTerm || match
    },

    resetSearchTerm () {
      this.$el.querySelector('#v-select-search').focus()
      this.searchTerm = ''
    },

    setSearchTermToSelected () {
      this.searchTerm = this.selectedInternal.name
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
          break
        case KEYCODES.up:
          this.decrementKeyboardFocus()
          break
        case KEYCODES.enter:
          if(this.filteredOptions.length && this.hasKeyboardFocus) { 
            this.selectOption(this.filteredOptions[this.highlightedOptionIndex])
          }
          break
        case KEYCODES.esc:
          document.activeElement.blur()
          break
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
      } else if (this.hasKeyboardFocus) {
        this.highlightedOptionIndex--
      }
    }
  }
}
</script>