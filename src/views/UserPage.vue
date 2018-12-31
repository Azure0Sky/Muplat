<template>
  <div>
    <div id="greet-msg">
      <h3>Hello! {{ username }}</h3>
    </div>
    <hr/>
    <PurchaseModal v-bind:price="purchasePrice" v-on:confirm="purchaseConfirm"></PurchaseModal>
    <div id="content-container" class="p-3">
      <p>Owned Music Number: <span>{{ musicNum }}</span></p>
      <table id="show-music-list" class="table table-striped table-borderless table-hover mt-1">
        <thead>
          <tr>
            <th scope="col">Artist Name</th>
            <th scope="col">Music Name</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="music in musicList" v-bind:key="music[1].toNumber()">
            <td>{{music[0]}}</td>
            <td>{{music[4]}}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div id="search-container" class="p-3 float-right">
      <form class="form-inline my-2 my-lg-0 float-right">
        <input class="form-control sm" type="search" placeholder="Search" aria-label="Search" v-model="keyword">
        <button class="btn btn-outline-info my-2 my-sm-0 ml-3" type="button" v-on:click="search">Search</button>
      </form>
      <table id="search-result" class="table table-striped table-borderless table-hover mt-2 float-right" v-show="searchSuccessfully && !searchFailed">
        <thead>
          <tr>
            <th scope="col">Artist Name</th>
            <th scope="col">Price(ETH)</th>
            <th scope="col">Release Time</th>
            <th scope="col">Music Name</th>
          </tr>
        </thead>
        <tbody>
          <MusicItem v-for="music in searchRes" v-bind:item="music" v-bind:key="music[1].toNumber()" v-on:prePurchase="prePurchase"></MusicItem>
        </tbody>
      </table>
      <div id="search-failed-msg" class="mt-5" v-show="searchFailed">No music found!</div>
    </div>
  </div>
</template>

<script>
import MusicItem from '../components/MusicItem'
import PurchaseModal from '../components/PurchaseModal'

export default {
  name: 'UserPage',
  components: {PurchaseModal, MusicItem},
  data () {
    return {
      username: null,
      musicNum: 0,
      musicList: [],
      keyword: '',
      searchSuccessfully: false,
      searchFailed: false,
      searchRes: [],
      purchaseMid: 0,
      purchasePrice: 0
    }
  },

  methods: {
    search () {
      this.searchSuccessfully = false
      this.searchFailed = false
      window.bc.contract('Muplat').SearchMusicByExactName.call(this.keyword, (err, res) => {
        if (err) {
          console.log(err)
        }

        if (res.length === 0) {
          this.searchFailed = true
        } else {
          for (let id of res) {
            window.bc.contract('Muplat').GetMusicInfo.call(id, (err, res) => {
              if (err) {
                console.log(err)
              }

              this.searchRes.push(res)
              this.searchSuccessfully = true
            })
          }
        }
      })
    },

    prePurchase (mid, price) {
      this.purchaseMid = mid
      this.purchasePrice = price
    },

    purchaseConfirm () {
      window.bc.contract('Muplat').PurchaseMusic(
        this.purchaseMid,
        {
          from: window.bc.web3().eth.coinbase,
          value: window.bc.web3().toWei(this.purchasePrice, 'ether'),
          gas: 900000
        },
        (err) => {
          if (err) {
            alert(err)
          } else {
            alert('Purchase success!')
            this.updateUser()
          }
        }
      )
    },

    updateUser () {
      window.bc.contract('Muplat').GetUser.call((err, userInfo) => {
        if (err) {
          console.log(err)
        }

        this.musicNum = userInfo[1].toNumber()
        this.username = userInfo[2]

        let musicIdList = userInfo[3]
        if (!musicIdList) {
          console.log('No music')
          return
        }
        for (let id of musicIdList) {
          window.bc.contract('Muplat').GetMusicInfo.call(id, (err, res) => {
            if (err) {
              console.log(err)
            }
            this.musicList.push(res)
          })
        }
      })
    }
  },

  created () {
    this.updateUser()
  }

}
</script>

<style scoped>
#content-container > p {
  font-size: 1.25rem;
}

#search-container {
  max-width: 60%;
}

#search-failed-msg {
  font-size: 1rem;
}
</style>
