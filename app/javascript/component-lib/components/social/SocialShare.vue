<template>
  <div 
    class="social--share" 
    :class="classes"
  >
    <span 
      class="social--share social__trigger icon--share" 
      @click="toggle" 
    />
    
    <div 
      class="social__target" 
      :class="{ 'active': isActive }"
    >
      <slot />
    </div>
  </div>
</template>

<script>
export default {
  name: 'SocialShare',

  props: {
    classes: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      isActive: false
    }
  },

  methods: {
    toggle () {
      this.isActive = !this.isActive
    }
  }
}
</script>