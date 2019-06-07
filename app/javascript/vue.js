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

import VForm from './component-lib/components/form/VForm'

import VMap from './component-lib/components/map/VMap'

import VNav from './component-lib/components/nav/VNav'

import VMultiselect from './component-lib/components/v-select/VMultiselect'
import VSelect from './component-lib/components/v-select/VSelect'
import VSelectSearchable from './component-lib/components/v-select/VSelectSearchable'

// Custom elements aren't supported by JSDOM, so break tests
// import defineCustomAriaElements from './component-lib/helpers/aria-definitions'
// defineCustomAriaElements()

import { polyfill as objectAssign } from 'es6-object-assign'
import { customPolyfill } from './component-lib/utils/custom-polyfills'
objectAssign()
customPolyfill()

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

document.addEventListener('DOMContentLoaded', () => { 
  if(document.getElementById('v-app')) {

    Vue.use(Vue2TouchEvents)

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
        VForm,
        VMap,
        VNav,
        VMultiselect,
        VSelect,
        VSelectSearchable
      }
    })
  }
})