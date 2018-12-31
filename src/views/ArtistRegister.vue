<template>
  <div>
    <h1>Artist Register</h1>
    <hr/>
    <div class="row">
      <div class="col-md-3">
        <form>
          <div class="form-group">
            <label for="artistNameInput">Name</label>
            <input id="artistNameInput" class="form-control" placeholder="Enter your name" type="text" v-model="artistName">
          </div>
          <button type="button" class="btn btn-raised btn-primary mt-3" v-bind:disabled="disableSubmit" v-on:click="performSubmit">Register</button>
        </form>

        <strong v-show="submitting">Submitting...</strong>
        <strong v-show="errorSubmit" class="text-danger">Error occurred!</strong>

        <p v-show="successMessage" class="text-success">
          <strong>You've been registered!</strong>
          <br>
          You will be redirected to the artist page <strong>once the block will be mined!</strong>
        </p>

      </div>
    </div>
  </div>
</template>

<script>
import mixin from '../libs/mixinViews'

export default {

  mixins: [mixin],
  name: 'ArtistRegister',

  data () {
    return {
      artistName: '',
      submitting: false,
      errorSubmit: false,
      successMessage: false,
      artistRegCheck: null,
      artistConnCheck: null
    }
  },

  computed: {
    disableSubmit () {
      return this.artistName.length === 0
    }
  },

  methods: {
    performSubmit () {
      this.submitting = true
      this.errorSubmit = false
      this.successMessage = false

      window.bc.contract('Muplat').ArtistRegister(
        this.artistName,
        {
          from: window.bc.web3().eth.coinbase,
          gas: 900000
        },
        (err) => {
          if (err) {
            alert(err)
            this.errorSubmit = true
          } else {
            this.successMessage = true

            Event.$emit('user-registered')
            this.redirectWhenBlockMined()
          }
        }
      )
    },

    redirectIfUserRegistered () {
      this.artistConnCheck = setInterval(() => {
        if (this.blockchainIsConnected()) {
          clearInterval(this.artistConnCheck)

          window.bc.contract('Muplat').GetArtist.call((err, res) => {
            // uid must greater than 0
            if (res[0].toNumber() !== 0) {
              this.$router.push('artist')
            }
          })
        }
      }, 500)
    },

    redirectWhenBlockMined () {
      this.artistRegCheck = setInterval(() => {
        if (this.blockchainIsConnected()) {
          window.bc.contract('Muplat').GetArtist.call((err, res) => {
            if (err) {
              console.log(err)
            } else if (res) {
              clearInterval(this.artistRegCheck)
              this.$router.push('artist')
            }
          })
        }
      }, 1000)
    }
  },

  created () {
    this.redirectIfUserRegistered()
  }

}
</script>

<style scoped>
  hr {
    border-color: dodgerblue;
    width: 100%;
    margin-bottom: 30px;
  }

  .btn {
    padding: 10px 25px;
  }
</style>
