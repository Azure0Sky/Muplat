<template>
  <div>
    <TopMenu id="top-menu"></TopMenu>
    <h2 v-show="!bcConnected && !bcConnectionError">
      Connecting...
    </h2>

    <div id="App" class="card" v-show="bcConnected && !bcConnectionError">
      <router-view class="card-body pb-2" id="container"></router-view>
    </div>

    <div v-show="bcConnectionError" class="mt-3">
      <h2>Error connecting to the blockchain!</h2>
      <h3 v-show="bcSmartContractAddressError">
        It seems like the address of the smart contract is wrong!
      </h3>
      <p>
        Please check:
      </p>
      <ul>
        <li>The blockchain is running.</li>
        <li>The port in your settings (file: <b>libs/mixinViews.js</b>) match with the blockchain configuration.</li>
        <li>The smart contract compiled JSON (file: <b>assets/UsersContract.json</b>) is updated.</li>
      </ul>
    </div>
  </div>
</template>

<script>
import TopMenu from './components/TopMenu'
import mixin from './libs/mixinViews.js'

export default {
  name: 'App',
  mixins: [mixin],
  components: {TopMenu}
}
</script>

<style>
  #top-menu {
    margin-bottom: 70px;
  }

  #App {
    width: 70%;
    margin: auto;
    padding: 40px;
    /*border: lightgray solid 2px;*/
    /*border-radius: 15px;*/
  }

  #container {
    max-height: 800px;
  }
</style>
