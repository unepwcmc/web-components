<template>
  <div class="map-filters flex flex-column">
    <dataset
      v-for="dataset in datasets"
      :key="dataset.id"
      :id="id+'_'+dataset.id"
      :config="dataset"
    ></dataset>
  </div>
</template>

<script>
import Dataset from "./Dataset.vue";

export default {
  name: "facet",

  components: { Dataset },

  props: {
    id: {
      required: true
    },
    datasets: {
      required: true,
      type: Array
    }
  }
};
</script>
