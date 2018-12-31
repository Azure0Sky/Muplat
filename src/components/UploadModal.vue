<template>
  <div class="modal fade" id="upload-modal" tabindex="-1" role="dialog" aria-labelledby="UploadModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="uploadTitle">Upload</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <form>
            <div class="form-group">
              <label for="music-name">Music Name</label>
              <input type="text" id="music-name" class="form-control" placeholder="Enter music name" v-model="musicName">
            </div>
            <div class="form-group">
              <label for="music-price">Price</label>
              <input type="number" required id="music-price" class="form-control" placeholder="Enter price" v-model="musicPrice">
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" disabled>Select File</button>
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" data-dismiss="modal" v-bind:disabled="disableConfirm" v-on:click="confirmUpload">Confirm</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UploadModal',

  data () {
    return {
      musicName: '',
      musicPrice: 0
    }
  },

  computed: {
    disableConfirm () {
      return this.musicName.length === 0 || this.musicPrice.toString().length === 0
    }
  },

  methods: {
    confirmUpload () {
      console.log('confirm')
      this.$emit('confirm', this.musicName, this.musicPrice)
    }
  }
}
</script>

<style scoped>

</style>
