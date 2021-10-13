<template>
  <div class="component-viewer flex">
    <aside class="filters flex-no-shrink">
      <ul class="filters__list">
        <li
          v-for="(category, index) in categoriesWithAll"
          :key="`component-viewer-category-${index}`"
          :class="{'filters__list-item--selected': isSelectedCategory(category.id)}"
        >
          <button
            aria-controls="component-grid"
            class="filters__list-item sg-h3 hover--pointer"
            @click="clickCategory(category.id)"
          >
            {{ category.name }}
          </button>
        </li>
      </ul>
    </aside>
    <main class="component-grid__wrapper">
      <h1 class="screen-reader">
        Component Viewer
      </h1>

      <ul
        id="component-grid"
        class="component-grid"
      >
        <li
          v-for="(comp, index) in filteredComponents"
          :key="`component-viewier-component-${index}`"
          class="component-grid__element sg-h3"
        >
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
    components: {
      type: Array,
      default: () => []
    },
    categories: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      selectedCategoryId: 'all'
    }
  },

  computed: {
    categoriesWithAll () {
      return [{id: 'all', name: 'All'}, ...this.categories]
    },

    filteredComponents () {
      return this.components.filter(this.belongsToSelectedCategory)
    }
  },

  methods: {
    getComponentPath (id) {
      return getComponentPath(id)
    },

    clickCategory (id) {
      this.selectedCategoryId = id
    },

    isSelectedCategory (id) {
      return id === this.selectedCategoryId
    },

    belongsToSelectedCategory (component) {
      return this.selectedCategoryId === 'all' ? true : component.category_id === this.selectedCategoryId
    }
  }
}
</script>