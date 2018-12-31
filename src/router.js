import Vue from 'vue'
import Router from 'vue-router'
import RegisterNav from './views/RegisterNav'
import UserRegister from './views/UserRegister'
import ArtistRegister from './views/ArtistRegister'
import UserPage from './views/UserPage'
import ArtistPage from './views/ArtistPage'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'register-nav',
      component: RegisterNav
    },
    {
      path: '/user-register',
      name: 'user-register',
      component: UserRegister
    },
    {
      path: '/artist-register',
      name: 'artist-register',
      component: ArtistRegister
    },
    {
      path: '/user',
      name: 'user-page',
      component: UserPage
    },
    {
      path: '/artist',
      name: 'artist-page',
      component: ArtistPage
    }
  ]
})
