import { focusMockerHub } from '../../vue'

export default {
  data () {
    return {
      currentMockFocusId: ''
    }
  },

  mounted () {
    focusMockerHub.$on('add-mock-focus', this.addMockFocus)
    focusMockerHub.$on('remove-mock-focus', this.removeMockFocus)
  },

  methods: {
    addMockFocus (id) {
      this.currentMockFocusId = id
    },

    removeMockFocus () {
      this.currentMockFocusId = ''
    },

    hasMockFocus (id) {
      return this.currentMockFocusId === '' ? false : id === this.currentMockFocusId
    }
  }
}