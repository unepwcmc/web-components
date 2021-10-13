// polyfills
import { polyfill } from 'es6-promise'
polyfill()

// dependencies
import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

Vue.use(Vuex)

// stores
import { storeModal } from './_store-modal.js'
import { storeToggle } from './_store-toggle.js'

export default new Vuex.Store({
  modules: {
    modal: storeModal,
    toggle: storeToggle
  }
})
