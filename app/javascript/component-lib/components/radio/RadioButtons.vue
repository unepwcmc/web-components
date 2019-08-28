<template>
  <div>
    <div class="flex flex-wrap">
      <p v-for="option in options" class="radio--rectangle flex no-margin">
        <input
          v-if="checkActiveState(option)"
          required
          type="radio"
          class="radio__input"
          v-model="input"
          :value="option.id"
          :name="name"
          :id="`${id}-${option.id}`"
          @click="changeInput(option.id, option.slug)">

        <label
          :for="`${id}-${option.id}`"
          class="radio__label flex flex-v-center flex-h-center"
          :class="{ 'radio__label--disabled': !checkActiveState(option) }">
          {{ option.title }}
        </label>
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'RadioButtons',

  mixins: [ mixinValidate ],

  props: {
    id: { required: true },
    options: { required: true },
    name: { required: true }
  },

  created () {
    this.changeInput(this.options[0].id, this.options[0].slug)
  },

  beforeDestroy () {
    eventHub.$off(this.resetEvent, this.reset)
  },

  computed: {
    showValidationError () {
      return this.errors != 0 && this.showValidationErrors
    },

    lowSubscription () {
      let restricted

      this.options.forEach(option => {
        if (!option.active) { restricted = true }
      })

      return restricted
    }
  },

  methods: {
    friendly (string) {
      return string.toLowerCase().replace(' ', '-')
    },

    labelClass (string) {
      return 'radio-button__label-' + this.friendly(string)
    },

    checkActiveState (option) {
      if('active' in option) {
        return option.active
      } else {
        return true
      }
    },

    validateField () {
      this.resetErrors()
      this.validateRequired()
      this.hasPassedValidation()
    },

    changeInput (text, slug) {
      this.input = text
      this.$store.commit('formReports/updateFormField', { name: this.name, value: this.input })

      if(this.trackSlug) { this.$store.commit('formReports/updateFormField', { name: 'slug', value: slug }) }
      
      this.validateField()
    },

    hideFromForm () {
      this.input = ''
      this.resetErrors()
      this.resetPassed()
    },

    reset () {
      this.input = ''
      this.resetPassed()
      this.validateField()
      this.$store.commit('formReports/updateFormField', { name: this.name, value: '' })
      this.changeInput(this.options[0].id, this.options[0].slug)
    }
  }
}
</script>
