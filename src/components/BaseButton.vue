<template>
  <button class="btn btn-raised btn-info" v-on:click="RegBtnClick">
    <span><i class="material-icons">account_circle</i>  {{ msg }}</span>
  </button>
</template>

<script>
export default {
  name: 'BaseRegButton',
  props: {
    msg: {
      type: String,
      required: true,
      default: 'None'
    }
  },
  methods: {
    RegBtnClick: function () {
      this.$emit('ClickEvent')
    }
  }
}
</script>

<style scoped>
span {
  display: inline-flex;
  align-items: center;
  white-space: pre-wrap;
}
</style>
