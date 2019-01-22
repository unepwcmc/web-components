<template>
  <div>
    <template v-for="filter, index in filters">
      <h3>{{ filter.name }}</h3>
      <facet :id="filter.id" :datasets="filter.datasets"></facet>
    </template>
  </div>
</template>

<script>
import Facet from "./Facet.vue";

export default {
  name: "filters",

  components: { Facet },

  props: {
    filters: {
      default: () => [],
      type: Array
    }
  }
};
</script>
