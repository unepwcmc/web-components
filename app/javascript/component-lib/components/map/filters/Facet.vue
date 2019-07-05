<template>
  <div class="map-filters flex flex-column">
    <dataset
      v-for="dataset in datasets"
      :id="id+'_'+dataset.id"
      :key="dataset.id"
      :config="dataset"
    />
  </div>
</template>

<script>
import Dataset from './Dataset.vue'

export default {
  name: 'Facet',

  components: { Dataset },

  props: {
    id: {
      type: String,
      required: true
    },
    datasets: {
      required: true,
      type: Array
    }
  }
}
</script>
