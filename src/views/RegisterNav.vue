<template>
  <div id="reg-container">
    <div id="reg-msg">
      <h2>Please choose your identity</h2>
    </div>
    <div id="reg-btn-list">
      <BaseButton class="reg-btn" msg="User" v-on:ClickEvent="ToUserRegister"></BaseButton>
      <BaseButton class="reg-btn" msg="Artist" v-on:ClickEvent="ToArtistRegister"></BaseButton>
    </div>
  </div>
</template>

<script>
import BaseButton from '../components/BaseButton'

export default {
  name: 'RegisterNav',
  components: {BaseButton},
  methods: {
    ToUserRegister () {
      this.$router.push({path: '/user-register'})
    },
    ToArtistRegister () {
      this.$router.push({path: '/artist-register'})
    }
  }
}
</script>

<style scoped>
  #reg-msg > h2 {
    margin: auto;
    text-align: center;
  }

  #reg-msg {
    margin-bottom: 50px;
  }

  #reg-btn-list {
    display: block;
    text-align: center;
  }

  .reg-btn {
    display: inline-block;
    font-weight: bold;
    padding: 10px 25px;
    margin: 2%;
    letter-spacing: 1px;
  }
</style>
