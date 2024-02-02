<template>
  <div>
    <h1>Users</h1>

    <div>
      <input type="text" v-model="name" class="name-input input" placeholder="name" />
      <div v-if="errors.name" class="error">{{ errors.name }}</div>
    </div>

    <div>
      <input type="email" v-model="email" class="email-input input" placeholder="email" />
      <div v-if="errors.email" class="error">{{ errors.email }}</div>
    </div>

    <div>
      <country-select v-model="country" :country="country" topCountry="PT" class="country-input input" placeholder="country" countryName="true" />
      <div v-if="errors.country" class="error">{{ errors.country }}</div>
    </div>

    <div>
      <button v-if="isEditing" @click="updateUser" class="button-update">Update</button>
      <button v-if="isEditing" @click="cancelEdit" class="button-cancel">Cancel</button>

      <button v-else @click="createUser" class="button-create">Create</button>
    </div>

    <div v-for="user in users" :key="user.id" class="user-card">
      <h3>{{ user.name }}</h3>
      <h4>{{ user.email }}</h4>
      <h4>{{ user.country }}</h4>

      <button @click="editUser(user.id)" class="button-edit">Edit</button>
      <button @click="deleteUser(user.id)" class="button-delete">Delete</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';

const users = ref([]);
const name = ref('');
const email = ref('');
const country = ref('');
const user_id = ref(0);
const isEditing = ref(false);
const errors = ref({});
const API_URL = "http://localhost:3000/users";

onMounted(async () => {
    const res = await fetch(API_URL);
    users.value = await res.json();
});

const createUser = async () => {
    const res = await fetch(API_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            name: name.value,
            email: email.value,
            country: country.value
        })
    });

    const data = await res.json();

    if (!res.ok) {
      errors.value = {
        name: data.name ? data.name[0] : '',
        email: data.email ? data.email[0] : '',
        country: data.country ? data.country[0] : ''
      };
      toast("There are errors to be fixed", {"type": "error"})
      return
    }

    users.value.push(data);
    name.value = '';
    email.value = '';
    country.value = '';
    user_id.value = 0;
    errors.value = {}

    toast("User created successfully!", {"type": "success"})
};

const updateUser = async () => {
    const res = await fetch(`${API_URL}/${user_id.value}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            name: name.value,
            email: email.value,
            country: country.value,
            user_id: user_id.value
        })
    });

    const data = await res.json();

    if (!res.ok) {
      errors.value = {
        name: data.name ? data.name[0] : '',
        email: data.email ? data.email[0] : '',
        country: data.country ? data.country[0] : ''
      };
      toast("There are errors to be fixed", {"type": "error"})
      return
    }


    const index = users.value.findIndex(user => user.id === data.id);
    users.value[index] = data;

    name.value = '';
    email.value = '';
    country.value = '';
    user_id.value = 0;
    isEditing.value = false;
    errors.value = {};

    toast("User updated successfully!", {"type": "success"})

};

const cancelEdit = () => {
    name.value = '';
    email.value = '';
    country.value = '';
    user_id.value = 0;
    isEditing.value = false;
};

const deleteUser = async (id) => {
    await fetch(`${API_URL}/${id}`, {
        method: 'DELETE'
    });
    users.value = users.value.filter(user => user.id !== id);

    toast("User deleted successfully!", {"type": "success"})
};

const editUser = async (id) => {
    const user = users.value.find(user => user.id === id);

    name.value = user.name;
    email.value = user.email;
    country.value = user.country;
    user_id.value = user.id;
    isEditing.value = true;

    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
};

</script>

<style scoped>
  /* Container */
  .container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
  }

  /* Headings */
  h1 {
    font-size: 24px;
    margin-bottom: 20px;
    color: white;
  }

  h3 {
    font-size: 18px;
    margin-bottom: 5px;
    color: white;
  }

  h4 {
    font-size: 16px;
    color: grey;
  }

  /* Input Fields */
  .input {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    font-size: 16px;
    border: 1px solid #ddd;
    border-radius: 4px;
    box-sizing: border-box;
  }

  .input:focus {
    outline: none;
    border-color: #3498db;
    box-shadow: 0 0 10px rgba(52, 152, 219, 0.7);
  }

  .input::placeholder {
    color: #aaa;
  }

  /* Buttons */
  .button {
    display: inline-block;
    padding: 10px 20px;
    font-size: 16px;
    text-align: center;
    text-decoration: none;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .button-delete, .button-cancel {
    background-color: #db3434;
    color: #fff;
    margin: 6px
  }

  .button-edit, .button-update {
    background-color: #6093df;
    color: #333;
    margin: 6px
  }
  .button-create {
    background-color: #22a233;
    color: #333;
    margin: 6px
  }

  .button:hover {
    background-color: #2980b9;
  }

  /* User Card */
  .user-card {
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 20px;
  }

  .error {
    background-color: red;
    color: black;
    margin-top: 3px;
    margin-bottom: 3px;
  }

</style>
