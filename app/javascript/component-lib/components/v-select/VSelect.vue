<template>
  <div
    class="v-select relative"
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
      class="v-select__label hover--pointer"
    >
      <label
        :for="toggleId"
        class="v-select__selection"
      >{{ config.label }}</label>
      <slot name="label-icon" />
    </div>

    <button
      :id="toggleId"
      type="button"
      class="v-select__toggle"
      :class="{'v-select__toggle--active': isActive}"
      aria-haspopup="true"
      :aria-controls="dropdownId"
      :disabled="isDisabled"
      @click="toggleSelect"
    >
      <span class="v-select__dropdown-text">{{ selectionMessage }}</span>
      <i class="drop-arrow arrow-svg" />
    </button>

    <ul 
      v-show="isActive" 
      :id="dropdownId" 
      role="radiogroup" 
      class="v-select__dropdown"
    >
      <li
        v-for="option in options"
        :key="option.id"
        class="v-select__option"
      >
        <label
          class="v-select__option-label"
          :for="getOptionInputId(option)"
        >
          <input
            :id="getOptionInputId(option)"
            v-model="selectedInternal"
            class="v-select__default-radio"
            type="radio"
            :name="dropdownOptionsName"
            :value="option"
          >
          <span class="v-select__radio flex-no-shrink" />
          <span>{{ option.name }}</span>
        </label>
      </li>
    </ul>
  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'

const UNDEFINED_ID = '__UNDEFINED__'
const UNDEFINED_OBJECT = { id: UNDEFINED_ID, name: 'None' }
const DEFAULT_SELECT_MESSAGE = 'Select option'

export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect'}),
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeSelect', openCallback: 'openSelect'})
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
      type: Object,
      default: () => UNDEFINED_OBJECT
    }
  },

  data () {
    return {
      isActive: false,
      selectedInternal: null,
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id,

      mixinModalId: 'v-select-dropdown-' + this.config.id,
      mixinTriggerId: 'v-select-toggle-' + this.config.id,
      mixinIsRadioGroup: true
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
      this.selectedInternal = newSelectedOption === null ?
        UNDEFINED_OBJECT :
        newSelectedOption
    },

    selectedInternal (newSelectedInternal) {
      this.$emit('update:selected-option', newSelectedInternal)
    }
  },

  created () {
    this.initializeSelectedInternal()
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
    }
  }
}
</script>