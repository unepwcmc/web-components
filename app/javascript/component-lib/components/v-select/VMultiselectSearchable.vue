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

    <label 
      :for="selectedOptionsId"
      class="screen-reader"
    >
      Selected options
    </label>
    <ul
      :id="selectedOptionsId" 
      class="v-select__selected-options flex flex-wrap"
      role="listbox" 
    >
      <li
        v-for="(option, index) in selectedInternal"
        :key="getVForKey('selected-option', index)"
        role="option"
      >
        <button 
          class="v-select__selected-option flex flex-v-center hover--pointer"
          @click="deselectOption(option)"
        >
          {{ option.name }}
        </button>
      </li>
    </ul>

    <div :class="['v-select__search relative', {'v-select__search--active': isActive}]">
      <label
        class="screen-reader"
        :for="searchId"
      >{{ config.label }} search</label>
      <input
        :id="searchId"
        v-model="searchTerm"
        class="v-select__search-input"
        type="text"
        role="combobox"
        aria-haspopup="listbox"
        aria-autocomplete="list"
        :aria-expanded="showOptions.toString()"
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
          :id="searchResetId"
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
      class="v-select__dropdown"
    >
      <li
        v-for="(option, index) in filteredOptions"
        v-show="matchesSearchTerm(option)"
        :id="getOptionInputId(option)"
        :key="option.id"
        :class="['v-select__option hover--pointer', conditionalOptionClasses(option, index)]"
        role="option"
        :aria-selected="isHighlighted(index).toString()"
        @click.stop="selectOption(option)"
      >
        {{ option.name }}
      </li>
    </ul>
  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import mixinIds from '../../mixins/mixin-ids'
import mixinSelectShared from './mixins/mixin-select-shared'

export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect'}),
    mixinIds,
    mixinSelectShared
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
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      selectedInternal: []
    }
  },

  computed: {
    filteredOptions () {
      return this.options.filter(option =>
        this.matchesSearchTerm(option) && !this.isSelected(option))
    },

    selectedOptionsId () {
      return `${this.getComponentId()}-selected-options`
    },
  },

  watch: {
    searchTerm () {
      this.resetHighlightedIndex()
    },

    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption === null ?
        [] :
        newSelectedOption
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
      this.resetSearchTerm()
      this.resetHighlightedIndex()
      this.isActive = false
    },

    openSelect () {
      if (this.filteredOptions.length > 0) {
        this.searchTerm = ''
        this.isActive = true
      }
    },

    initializeSelectedInternal () {
      if (this.selected === null) {
        this.selectedInternal = []
      } else {
        this.selectedInternal = this.selected
      }
    },

    isSelected (option) {
      let isSelected = false
      
      this.selectedInternal.forEach(selectedOption => {
        if (selectedOption.id === option.id) {
          isSelected = true
        }
      })

      return isSelected
    },

    selectOption (option) {
      this.selectedInternal.push(option)

      const unselectedFiltersLength = this.filteredOptions.length

      if (unselectedFiltersLength === 0) {
        this.resetHighlightedIndex()
        this.closeSelect()
      } else if (this.highlightedOptionIndex >  unselectedFiltersLength - 1) {
        this.highlightedOptionIndex--
      }
    },

    deselectOption (deselectedOption) {
      this.selectedInternal = this.selectedInternal.filter(option => option.id !== deselectedOption.id )
    },

    conditionalOptionClasses (option, index) {
      return {
        'v-select__option--highlighted': this.isHighlighted(index)
      }
    }
  }
}
</script>