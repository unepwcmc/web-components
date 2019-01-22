import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Vue2TouchEvents from 'vue2-touch-events'

// store
import store from './component-lib/store/store.js'

// vue components
import Accordion from './component-lib/components/accordion/Accordion'
import AccordionItem from './component-lib/components/accordion/AccordionItem'

import ExpandableItem from './component-lib/components/expandable-item/ExpandableItem'

import Modal from './component-lib/components/modal/Modal'
import ModalTrigger from './component-lib/components/modal/ModalTrigger'

import Tooltip from './component-lib/components/tooltip/Tooltip'

import VMap from './component-lib/components/map/VMap'

import VNav from './component-lib/components/nav/VNav'

import VSelect from './component-lib/components/v-select/VSelect'

// Custom elements aren't supported by JSDOM, so break tests
// import defineCustomAriaElements from './component-lib/helpers/aria-definitions'
// defineCustomAriaElements()

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

document.addEventListener("DOMContentLoaded", () => { 
  if(document.getElementById('v-app')) {

    Vue.use(TurbolinksAdapter)
    Vue.use(Vue2TouchEvents)

    document.addEventListener('turbolinks:load', () => {
      const app = new Vue({
        el: '#v-app',
        store,

        components: { Accordion, AccordionItem, ExpandableItem, Modal, ModalTrigger, Tooltip, VMap, VNav, VSelect }
      })
    })
  }
})