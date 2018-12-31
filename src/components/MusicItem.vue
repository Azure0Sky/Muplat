<template>
  <tr data-toggle="modal" data-target="#purchase-modal" v-on:click="prePurchase">
    <td>{{item[0]}}</td>
    <td>{{price}}</td>
    <td>{{(new Date(item[3] * 1000)).toLocaleString()}}</td>
    <td>{{item[4]}}</td>
  </tr>
</template>

<script>
export default {
  name: 'MusicItem',
  props: {
    item: {
      type: Array,
      required: true
    }
  },

  data () {
    return {
      mid: this.item[1].toNumber(),
      price: window.bc.web3().fromWei(this.item[2].toNumber(), 'ether')
    }
  },

  methods: {
    prePurchase () {
      this.$emit('prePurchase', this.mid, this.price)
    }
  }
}
</script>

<style scoped>
tr {
  cursor: pointer;
}

td {
  white-space: nowrap;
}
</style>
