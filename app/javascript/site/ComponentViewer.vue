<template>
  <div class="flex">
  <aside class="filters flex-1-quarter">
    <ul class="filters__list ul--unstyled">
      <li v-for="category in categories" 
        :class="{'filters__list-item--selected': isSelectedCategory(category.id)}"
        @click="clickCategory(category.id)">
        <button class="filters__list-item sg-h3 hover--pointer">{{ category.name }}</button>
      </li>
    </ul>
  </aside>
  <main class="flex-3-quarters">
    <ul class="component-grid ul--unstyled page-container">
      <li v-for="comp in components" v-if="belongsToSelectedCategory(comp)" class="component-grid__element sg-h3">
        <a :href="getComponentPath(comp.id)">{{ comp.name }}</a>
      </li>
    </ul>
  </main>
</div>
</template>

<script>
import { getComponentPath } from './url-helpers'

export default {
  props: {
    components: Array,
    categories: Array
  },

  data () {
    return {
      selectedCategoryId: null
    }
  },

  computed: {
  },

  methods: {
    getComponentPath (id) {
      return getComponentPath(id)
    },

    clickCategory (id) {
      this.selectedCategoryId = this.selectedCategoryId === id ? null : id
    },

    isSelectedCategory (id) {
      return id === this.selectedCategoryId
    },

    belongsToSelectedCategory (component) {
      return this.selectedCategoryId === null ? true : component.category_id === this.selectedCategoryId
    }
  }
}
</script>