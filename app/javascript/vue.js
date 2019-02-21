import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Vue2TouchEvents from 'vue2-touch-events'

// store
import store from './component-lib/store/store.js'

// site
import ComponentViewer from './site/ComponentViewer'

// vue components
import Accordion from './component-lib/components/accordion/Accordion'
import AccordionItem from './component-lib/components/accordion/AccordionItem'

import Carousel from './component-lib/components/carousel/Carousel'
import CarouselSlide from './component-lib/components/carousel/CarouselSlide'

import ChartArea from './component-lib/components/charts/ChartArea'
import ChartColumn from './component-lib/components/charts/ChartColumn'
import ChartDoughnut from './component-lib/components/charts/ChartDoughnut'
import ChartLine from './component-lib/components/charts/ChartLine'
import ChartRow from './component-lib/components/charts/ChartRow'
import ChartRowStacked from './component-lib/components/charts/ChartRowStacked'

import ExpandableItem from './component-lib/components/expandable-item/ExpandableItem'

import Modal from './component-lib/components/modal/Modal'
import ModalTrigger from './component-lib/components/modal/ModalTrigger'

import StickyBar from './component-lib/components/sticky/StickyBar'

import Tab from './component-lib/components/tabs/Tab'
import Tabs from './component-lib/components/tabs/Tabs'

import Tooltip from './component-lib/components/tooltip/Tooltip'

import VMap from './component-lib/components/map/VMap'

import VNav from './component-lib/components/nav/VNav'

import VSelect from './component-lib/components/v-select/VSelect'

// Custom elements aren't supported by JSDOM, so break tests
// import defineCustomAriaElements from './component-lib/helpers/aria-definitions'
// defineCustomAriaElements()

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

import FocusMockerHub from './component-lib/utils/focus-mocker-hub.js'
export const focusMockerHub = new Vue(FocusMockerHub)

document.addEventListener('DOMContentLoaded', () => { 
  if(document.getElementById('v-app')) {

    Vue.use(TurbolinksAdapter)
    Vue.use(Vue2TouchEvents)

    document.addEventListener('turbolinks:load', () => {
      const app = new Vue({
        el: '#v-app',
        store,

        components: { 
          Accordion,
          AccordionItem,
          Carousel,
          CarouselSlide,
          ChartArea,
          ChartColumn,
          ChartDoughnut,
          ChartLine,
          ChartRow,
          ChartRowStacked,
          ComponentViewer,
          ExpandableItem,
          Modal,
          ModalTrigger,
          StickyBar,
          Tab,
          Tabs,
          Tooltip,
          VMap,
          VNav,
          VSelect
        }
      })
    })
  }
})