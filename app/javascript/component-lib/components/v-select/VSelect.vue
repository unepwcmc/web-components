<template>
  <div class="v-select relative hover--pointer" :class="{'v-select--disabled': isDisabled}">
    <input type="hidden" :name="config.id" :id="config.id" v-model="selectedInternal.name" />

    <div class="v-select__label hover--pointer">
      <label :for="toggleId" class="v-select__selection">{{ config.label }}</label>
      <slot name="label-icon"></slot>
    </div>

    <button
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
      :aria-multiselectable="isMultiselect" 
      :role="popupRole" 
      class="v-select__dropdown">

      <li
        class="v-select__option"
        v-for="option in options"
        :key="option.id">
        <input
          :class="defaultInputClass"
          :id="getOptionInputId(option)"
          :data-mock-focus-id="getMockFocusId(option)"
          :name="dropdownOptionsName"
          :type="inputType"
          :value="option"
          v-model="selectedInternal"
          @change="handleOptionChange(option)">
        <span :id="getMockFocusId(option)" :class="getMockInputClasses(option)">Fake</span>
        <label :for="getOptionInputId(option)">{{ option.name }}</label>
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
const DEFAULT_SELECT_MESSAGE = 'Select option'
const DEFAULT_MULTISELECT_MESSAGE = 'Select options'

export default {
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

  mixins: [mixinPopupCloseListeners('closeSelect'), mixinFocusCapture('isActive'), mixinFocusMocker],

  data () {
    return {
      isActive: false,
      isMultiselect: this.config.isMultiple,
      selectedInternal: null,
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id,
      popupRole: this.config.isMultiple ? 'group' : 'radiogroup',
      inputType: this.config.isMultiple ? 'checkbox' : 'radio',

      mixinModalId: 'v-select-dropdown-' + this.config.id,
      mixinTriggerId: 'v-select-toggle-' + this.config.id,
      mixinIsRadioGroup: !this.config.isMultiple
    }
  },

  methods: {
    closeSelect () {
      this.isActive = false
    },

    toggleSelect () {
      this.isActive = this.options.length ? !this.isActive : false
    },

    initializeSelectedInternal () {
      if (this.selected === null) {
        this.selectedInternal = this.isMultiselect ? [] : UNDEFINED_OBJECT
      } else {
        this.selectedInternal = this.selected
      }
    },

    handleOptionChange (selected) {
      this.$emit('update:selected-option', this.selectedInternal)
    },

    isSelected (option) {
      if(this.isMultiselect) { 
        return this.selectedInternal.find(selectedOption => option.id === selectedOption.id)
      }

      return option.id === this.selectedInternal.id
    },

    getOptionInputId (option) {
      return `option-${this.config.id}-${option.id}`
    },

    getMockFocusId (option) {
      return this.getOptionInputId(option) + '-mock-focus'
    },

    getMockInputClasses (option) {
      const inputClass = `v-select__${this.inputType}`

      return {
        [inputClass]: true,
        [`${inputClass}--active`]: this.isSelected(option),
        'focussed': this.getMockFocusId(option) === this.currentMockFocusId
      }
    },

    hasFocus(option) {
      return document.activeElement.id === this.getOptionInputId(option)
    }
  },

  computed: {
    isDisabled () {
      return !this.options.length
    },

    selectionMessage () {
      if (this.isMultiselect) {
        const selectedNames = this.selectedInternal.map(option => option.name)

        return selectedNames.length ? selectedNames.join(', ') : DEFAULT_MULTISELECT_MESSAGE
      }

      return this.selectedInternal.id === UNDEFINED_ID ? DEFAULT_SELECT_MESSAGE : this.selectedInternal.name
    },

    defaultInputClass () {
      return `v-select__default-${this.inputType}`
    }
  },

  created () {
    this.initializeSelectedInternal()
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption
    }
  }
}
</script>

<style lang="scss">
.v-select--disabled {
  opacity: 0.5;
}
.v-select__toggle--active {
  .drop-arrow {
    transform: rotate(180deg)
  }
}

.v-select__radio--active {
  font-weight: bolder
}
.v-select__checkbox--active {
  font-weight: bolder
}

.focussed {
  outline: solid 1px blue;
}
</style>

