<template>
  <div class="modal fade" id="purchase-modal" tabindex="-1" role="dialog" aria-labelledby="PurchaseModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="purchaseTitle">Purchase</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <strong class="my-2">Are you sure to purchase this music?</strong>
          <p class="my-2">The cost is <strong>{{price}}</strong> ETH</p>
        </div>
        <div class="modal-footer mb-2">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" data-dismiss="modal" v-on:click="$emit('confirm')">Confirm</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PurchaseModal',

  props: {
    price: {
      required: true
    }
  }
}
</script>

<style scoped>
.modal-body > p, strong {
  font-size: 1.1rem;
}
</style>
