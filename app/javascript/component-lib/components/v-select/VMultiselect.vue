<template>
  <div class="v-select relative" :class="{'v-select--disabled': isDisabled}">
    <input type="hidden" :name="config.id" :id="config.id" v-model="selectedInternal" />

    <div v-if="config.label" class="v-select__label hover--pointer">
      <label :for="toggleId" class="v-select__selection">{{ config.label }}</label>
      <slot name="label-icon"></slot>
    </div>

    <button
      type="button"
      class="v-select__toggle"
      :class="{'v-select__toggle--active': isActive}"
      :id="toggleId"
      aria-haspopup="true"
      :aria-controls="dropdownId"
      :disabled="isDisabled"
      @click="toggleSelect">
      <span class="v-select__dropdown-text">{{ selectionMessage }}</span>
      <i class="drop-arrow arrow-svg"/>
    </button>

    <ul 
      v-show="isActive" 
      :id="dropdownId" 
      aria-multiselectable="true" 
      role="group" 
      class="v-select__dropdown ul--unstyled">

      <li
        class="v-select__option"
        v-for="option in options"
        :key="option.id">
        <label :for="getOptionInputId(option)">
          <input
            class="v-select__default-checkbox"
            type="checkbox"
            :id="getOptionInputId(option)"
            :data-mock-focus-id="getMockFocusId(option)"
            :name="dropdownOptionsName"
            :value="option"
            v-model="selectedInternal">
          <span :id="getMockFocusId(option)" :class="['flex-no-shrink', getMockInputClasses(option)]"></span>
          <span>{{ option.name }}</span>
        </label>
      </li>

    </ul> 

  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import mixinFocusMocker from '../../mixins/mixin-focus-mocker'

const UNDEFINED_ID = '__UNDEFINED__';
const UNDEFINED_OBJECT = { id: UNDEFINED_ID, name: 'None' }
const DEFAULT_MULTISELECT_MESSAGE = 'Select options'

export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect'}),
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeSelect', openCallback: 'openSelect'}),
    mixinFocusMocker
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
        default: () => [],
      }
  },

  created () {
    this.initializeSelectedInternal()
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption
    },

    selectedInternal (newSelectedInternal) {
      this.$emit('update:selected-option', newSelectedInternal)
    }
  },

  data () {
    return {
      isActive: false,
      selectedInternal: [],
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id,

      mixinModalId: 'v-select-dropdown-' + this.config.id,
      mixinTriggerId: 'v-select-toggle-' + this.config.id,
    }
  },

  computed: {
    isDisabled () {
      return !this.options.length
    },

    selectionMessage () {
      const selectedNames = this.selectedInternal.map(option => option.name)

      return selectedNames.length ? selectedNames.join(', ') : DEFAULT_MULTISELECT_MESSAGE
    }
  },

  methods: {
    closeSelect () {
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
        this.selectedInternal =  []
      } else {
        this.selectedInternal = this.selected
      }
    },

    isSelected (option) {
      return this.selectedInternal.find(selectedOption => option.id === selectedOption.id)
    },

    getOptionInputId (option) {
      return `option-${this.config.id}-${option.id}`
    },

    getMockFocusId (option) {
      return this.getOptionInputId(option) + '-mock-focus'
    },

    getMockInputClasses (option) {
      const inputClass = 'v-select__checkbox'

      return {
        [inputClass]: true,
        [`${inputClass}--active`]: this.isSelected(option),
        'focussed': this.hasMockFocus(this.getMockFocusId(option))
      }
    }
  }
}
</script>