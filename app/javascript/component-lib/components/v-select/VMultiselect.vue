<template>
  <div
    class="v-select relative"
    :class="{'v-select--disabled': isDisabled}"
  >
    <input
      :id="config.id"
      v-model="selectedInternal"
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
      aria-multiselectable="true" 
      role="group" 
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
            class="v-select__default-checkbox"
            type="checkbox"
            :name="dropdownOptionsName"
            :value="option"
          >
          <span class="v-select__checkbox flex-no-shrink" />
          <span>{{ option.name }}</span>
        </label>
      </li>
    </ul>
  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'

const DEFAULT_MULTISELECT_MESSAGE = 'Select options'

export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect'}),
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeSelect', openCallback: 'openSelect'}),
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
      default: () => [],
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

  watch: {
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
    }
  }
}
</script>