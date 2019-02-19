<template>
  <div class="flex">
  <aside class="filters flex-1-quarter">
    <ul class="filters__list ul--unstyled">
      <li v-for="comp in components">
        <button class="filters__list-item sg-h3 hover--pointer">{{ comp.name }}</button>
      </li>
    </ul>
  </aside>
  <main class="flex-3-quarters">
    <ul class="component-grid ul--unstyled page-container">
      <li v-for="comp in components" class="component-grid__element">
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
    components: Array
  },

  methods: {
    getComponentPath (id) {
      return getComponentPath(id)
    }
  }
}
</script>