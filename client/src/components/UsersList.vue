<template>
    <div>
        <h1>Users</h1>
        <input type="text" v-model="name" class="name-input input" placeholder="name" />
        <input type="text" v-model="email" class="email-input input" placeholder="email" />
        <input type="dropdown" v-model="country" class="country-input input" placeholder="country"/>

        <button v-if="isEditing" @click="updateUser">Update</button>
        <button v-if="isEditing" @click="cancelEdit">Edit</button>

        <button v-else @click="createUser">Create</button>

        <div v-for="user in users" :key="name.id">
            <h3>{{ user.name }}</h3>
            <h4>{{ user.email }}</h4>
            <h4>{{ user.country }}</h4>

            <button @click="editUser(user.id)">Edit</button>
            <button @click="deleteUser(user.id)">Delete</button>

        </div>

    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const users = ref([])
const name = ref('')
const email = ref('')
const country = ref('')
const user_id = ref(0)
const isEditing = ref(false)
const API_URL = "http://localhost:3000/users";


onMounted(async () => {
    const res = await fetch(API_URL)
    users.value = await res.json()
})


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
    })

    const data = await res.json()

    users.value.push(data)
    name.value = ''
    email.value = ''
    country.value = ''
    user_id.value = 0;
}

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
    })

    const data = await res.json()

    const index = users.value.findIndex(user => user.id === data.id)
    users.value[index] = data

    name.value = ''
    email.value = ''
    country.value = ''
    user_id.value = 0;
    isEditing.value = false
}

const cancelEdit = () => {
    name.value = ''
    email.value = ''
    country.value = ''
    user_id.value = 0;
    isEditing.value = false
}

const deleteUser = async (id) => {
    await fetch(`${API_URL}/${id}`, {
        method: 'DELETE'
    })
    users.value = users.value.filter(user => user.id !== id)
}

const editUser = async (id) => {
    const user = users.value.find(user => user.id === id)

    name.value = user.name
    email.value = user.email
    country.value = user.country
    user_id.value = user.id
    isEditing.value = true

    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    })
}
</script>

<style scoped>
/* Assuming you have a class named 'input' for your input elements */
.input {
    display: block;
    width: 100%;
    padding: 8px;
    margin-bottom: 10px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

/* Optional: Style for focused input */
.input:focus {
    outline: none;
    border-color: #2196F3;
    /* Change color to match your design */
    box-shadow: 0 0 5px rgba(33, 150, 243, 0.7);
    /* Change color to match your design */
}

/* Optional: Placeholder color */
.input::placeholder {
    color: #999;
    /* Change color to match your design */
}

/* Optional: Disabled input styles */
.input:disabled {
    background-color: #f0f0f0;
    cursor: not-allowed;
}
</style>