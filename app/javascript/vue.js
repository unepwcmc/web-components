import Vue from 'vue/dist/vue.esm'
import Vue2TouchEvents from 'vue2-touch-events'

// store
import store from './component-lib/store/store.js'


import FilterableTable from '@unep-wcmc/wcmc-components'
Vue.use(FilterableTable, { store })
// site
import ComponentViewer from './site/ComponentViewer'

// vue components
import Accordion from './component-lib/components/accordion/Accordion'
import AccordionItem from './component-lib/components/accordion/AccordionItem'
import Carousel from './component-lib/components/carousel/Carousel'
import CarouselSlide from './component-lib/components/carousel/CarouselSlide'
import ChartArea from './component-lib/components/charts/ChartArea'
import ChartColumn from './component-lib/components/charts/ChartColumn'
import ChartDial from './component-lib/components/charts/ChartDial'
import ChartLine from './component-lib/components/charts/ChartLine'
import ChartRow from './component-lib/components/charts/ChartRow'
import ChartRowStacked from './component-lib/components/charts/ChartRowStacked'
import ExpandableItem from './component-lib/components/expandable-item/ExpandableItem'
import Modal from './component-lib/components/modal/Modal'
import ModalTrigger from './component-lib/components/modal/ModalTrigger'
import StickyBar from './component-lib/components/sticky/StickyBar'
import Tab from './component-lib/components/tabs/Tab'
import Tabs from './component-lib/components/tabs/Tabs'
import TabFake from './component-lib/components/tabs/TabFake'
import TabsFake from './component-lib/components/tabs/TabsFake'
import Tooltip from './component-lib/components/tooltip/Tooltip'
import Toggle from './component-lib/components/toggle/Toggle'
import VForm from './component-lib/components/form/VForm'
import VMap from './component-lib/components/map/VMap'
import VNav from './component-lib/components/nav/VNav'
import VMultiselect from './component-lib/components/v-select/VMultiselect'
import VMultiselectSearchable from './component-lib/components/v-select/VMultiselectSearchable'
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
export const eventHub = new Vue() //No longer doing it this way
Vue.prototype.$eventHub = new Vue()

document.addEventListener('DOMContentLoaded', () => { 
  if(document.getElementById('v-app')) {

    Vue.use(Vue2TouchEvents)

    new Vue({
      el: '#v-app',
      store,

      components: { 
        Accordion,
        AccordionItem,
        Carousel,
        CarouselSlide,
        ChartArea,
        ChartColumn,
        ChartDial,
        ChartLine,
        ChartRow,
        ChartRowStacked,
        ComponentViewer,
        ExpandableItem,
        // FilterableTable,
        Modal,
        ModalTrigger,
        StickyBar,
        Tab,
        Tabs,
        TabFake,
        TabsFake,
        Toggle,
        Tooltip,
        VForm,
        VMap,
        VNav,
        VMultiselect,
        VMultiselectSearchable,
        VSelect,
        VSelectSearchable
      }
    })
  }
})