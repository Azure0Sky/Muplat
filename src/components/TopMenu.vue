<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <!--<router-link tag="li" class="nav-link" to="/profile" exact v-show="registered">-->
        <!--<a>Profile</a>-->
        <!--</router-link>-->
        <router-link tag="li" class="nav-item" v-bind:to="home" exact>
          <a class="nav-link">Home</a>
        </router-link>

        <li class="nav-link">
          <strong v-bind:class="connectedClass">
            {{ bcConnected ? 'Connected' : 'Not Connected' }}
          </strong>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
// importing common function
import mixin from '../libs/mixinViews'

export default {
  mixins: [mixin],

  data () {
    return {
      connCheck: null,
      artistRegCheck: null, // contain the intervalID given by setInterval
      connectedClass: 'text-danger', // bootstrap class for the connection status (red when not connected, green when connected)
      registered: false, // true when the user that is visiting the page is registered
      home: '/'
    }
  },

  methods: {
    checkUser () {
      this.userRegCheck = setInterval(() => {
        if (this.blockchainIsConnected()) {
          window.bc.contract('Muplat').GetUser.call((err, res) => {
            if (err) {
              console.log(err)
            } else if (res) {
              clearInterval(this.artistRegCheck)
              this.registered = !!res.uid
            }
          })
        }
      }, 1000)
    },

    checkConnection () {
      this.connCheck = setInterval(() => {
        if (this.blockchainIsConnected()) {
          clearInterval(this.connCheck)
          this.connectedClass = 'text-success'
        }
      }, 500)
    }
  },

  created () {
    Event.$on('user-registered', this.checkUser)
    this.checkConnection()
  }
}
</script>

<style>
</style>
