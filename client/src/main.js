import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import vueCountryRegionSelect from 'vue3-country-region-select'


createApp(App).use(vueCountryRegionSelect)
                            .mount('#app')