<script setup>
import { ref } from 'vue'

const messages = ref([])
const inputText = ref('')
const users = ref([])

const socketUrl = "ws://localhost:4001/socket/websocket"

const socket = new WebSocket(socketUrl)

const generateRandomRef = () => Math.floor(Math.random() * 1000000)

function joinTopic(topic, payload = {}) {
  socket.onopen = () => {
    const joinMessage = {
      topic: topic,
      event: "phx_join",
      payload: payload,
      ref: generateRandomRef()
    }

    socket.send(JSON.stringify(joinMessage))

    console.log(`Attempting to join topic: ${topic}`)
  }

  socket.onmessage = (event) => {
    const response = JSON.parse(event.data)


    if (response.event === 'shout') {
      messages.value.push(response.payload)
    }

    if (response.event === 'user_joined') {
      users.value.push(response.payload.handle)
    }

    if (response.event === 'user_disconnected') {
      const handle = response.payload.handle

      users.value = users.value.filter(saved_handle => saved_handle !== handle)
    }
  }

  socket.onerror = (error) => {
    console.error("WebSocket error:", error)
  }

  socket.onclose = (event) => {
    console.log("WebSocket closed:", event)
  }
}

function sendMessage() {
  const message = {
    topic: "room:lobby",
    event: "shout",
    payload: {body: inputText.value},
    ref: generateRandomRef()
  }

  socket.send(JSON.stringify(message))
  inputText.value = ''
}

joinTopic("room:lobby")
</script>

<template lang="pug">
.messages
  .message(v-for="message in messages") {{ message.body }}

input.input(
  v-model="inputText"
  @keydown.enter="sendMessage"
)

ul.users
  li.user(v-for="user in users") {{ user }}
</template>

<style>
.app
  display: flex
  align-items: center
  display: flex
  justify-content: center
  min-height: 100vh
  flex-direction: column
  gap: 10px
  background: #d4d4d4

.input
  border-radius: 4px
  border: 1px solid #ddd
  padding: 10px
  width: 50%
  outline: none
  max-width: 80ch

body
  margin: 0

input, textarea, select
  box-sizing: border-box
</style>
