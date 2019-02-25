<template>
  <div class="component-viewer flex">
  <aside class="filters flex-no-shrink">
    <ul class="filters__list ul--unstyled">
      <li v-for="category in categories" 
        :class="{'filters__list-item--selected': isSelectedCategory(category.id)}">
        <button
          aria-controls="component-grid"
          class="filters__list-item sg-h3 hover--pointer"
          @click="clickCategory(category.id)">{{ category.name }}</button>
      </li>
    </ul>
  </aside>
  <main id="component-grid">
    <ul class="component-grid ul--unstyled">
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