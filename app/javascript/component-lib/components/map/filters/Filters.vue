<template>
  <div>
    <template v-for="filter, index in filters">
      <h2>{{ filter.name }}</h2>
      <facet
        :id="filter.id"
        :datasets="filter.datasets"
      />
    </template>
  </div>
</template>

<script>
import Facet from './Facet.vue'

export default {
  name: 'Filters',

  components: { Facet },

  props: {
    filters: {
      default: () => [],
      type: Array
    }
  }
}
</script>
