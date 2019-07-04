<template>
  <div class="v-form">
    <slot />
    <em
      v-if="error"
      class="v-form__error"
    >{{ errorMessage }}</em>

    <div
      v-if="isPopupActive"
      class="v-form__overlay"
    >
      <div 
        :id="mixinModalId"
        class="v-form__success flex flex-column flex-center"
      >
        <div
          class="v-form__success-icon icon--tick"
          title="Success"
        />
        <h1 class="v-form__success-title">
          {{ title }}
        </h1>
        <p class="v-form__success-message">
          {{ successMessage }}
        </p>
        <button
          :aria-haspopup="true"
          :aria-controls="mixinModalId"
          :aria-expanded="true"
          class="v-form__success-button button button--grey"
          @click="close"
        >
          Close
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { setCsrfToken } from '../../helpers/request-helpers'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import axios from 'axios'

export default {
  mixins: [ mixinFocusCapture({toggleVariable: 'isPopupActive'}) ],

  props: {
    title: String,
    errorMessage: String,
    successMessage: String,
  },

  data() {
    return {
      isPopupActive: false,
      error: false,
      mixinModalId: 'v-form-modal' + this._uid
    }
  },

  mounted() {
    setCsrfToken(axios)
    this.addSubmitListener()
  },

  methods: {
    open() {
      this.error = false
      this.isPopupActive = true
    },

    close() {
      this.error = false
      this.isPopupActive = false
    },

    handleException () {
      this.error = true
      this.$nextTick(() => {
        this.$el.querySelector('.v-form__error').scrollIntoView()
      })
    },

    handleSuccess() {
      this.open()
    },

    addSubmitListener() {
      const form = this.$el.querySelector('form')

      form.addEventListener('submit', e => {
        const data = new FormData(form)
        const action = form.getAttribute('action')

        e.preventDefault()
        
        Math.random() < 0.5 ? this.handleSuccess() : this.handleException()
        // axios.post(action, data)
        //   .then(response => {
        //     this.handleSuccess()
        //   })
        //   .catch(error => {
        //     this.handleException()
        //   })
      })
    }
  }
}
</script>

