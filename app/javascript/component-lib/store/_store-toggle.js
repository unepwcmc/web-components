export const storeToggle = {
  namespaced: true,

  state: { },

  actions: {
    updateToggleState ({ commit }, toggle) {
      commit('updateToggle', toggle)
    }
  },

  mutations: {
    updateToggle (state, toggle) {
      this.state.toggle[toggle.id] = toggle.isActive
    }
  }
}