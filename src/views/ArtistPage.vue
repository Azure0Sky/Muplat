<template>
  <div>
    <div id="greet-msg">
      <h3>Hello! {{ artistName }} <span>ID: {{ aid }}</span></h3>
    </div>
    <hr/>
    <UploadModal v-on:confirm="uploadConfirmed"></UploadModal>
    <div id="content-container" class="p-3">
      <p>Your Music: </p>
      <table id="show-work-table" class="table table-striped table-borderless table-hover mt-1">
        <thead>
          <tr>
            <th scope="col">ID</th>
            <th scope="col">Price(ETH)</th>
            <th scope="col">Release Time</th>
            <th scope="col">Name</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="music in musicList" v-bind:key="music[1].toNumber()">
            <td>{{music[1].toNumber()}}</td>
            <td>{{window.bc.web3().fromWei(music[2].toNumber(), 'ether')}}</td>
            <td>{{(new Date(music[3] * 1000)).toLocaleString()}}</td>
            <td>{{music[4]}}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div id="upload-container">
      <button class="btn btn-outline-primary btn-lg py-2 px-4" id="upload-btn" data-toggle="modal" data-target="#upload-modal">Upload</button>
    </div>
  </div>
</template>

<script>
import UploadModal from '../components/UploadModal'

export default {
  name: 'ArtistPage',
  components: {UploadModal},

  data () {
    return {
      artistName: '',
      aid: 0,
      musicList: [],
      window: null
    }
  },

  methods: {
    uploadConfirmed (musicName, musicPrice) {
      console.log('confirm upload')
      window.bc.contract('Muplat').UploadMusic(
        window.bc.web3().toWei(musicPrice, 'ether'),
        musicName,
        {
          from: window.bc.web3().eth.coinbase,
          gas: 900000
        },
        (err) => {
          if (err) {
            alert(err)
          } else {
            alert('Upload success!')
            this.updateArtist()
          }
        }
      )
    },

    updateArtist () {
      window.bc.contract('Muplat').GetArtist.call((err, artistInfo) => {
        if (err) console.log(err)
        this.aid = artistInfo[0].toNumber()
        this.artistName = artistInfo[1]

        let musicIdList = artistInfo[2]
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
    this.window = window
    this.updateArtist()
  }
}
</script>

<style scoped>
#upload-container {
  float: right;
}

#content-container > p {
  font-size: 1.25rem;
}

h3 > span {
  float: right;
}

#show-work-table {
  font-size: 1rem;
}
</style>
