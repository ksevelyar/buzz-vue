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

    if (response.event === 'user_list') {
      users.value = response.payload.users
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
.grid-container
  .grid-item.input-wrapper
    input.input(v-model="inputText" @keydown.enter="sendMessage" autofocus)

  .grid-item.messages
    .message(v-for="message in messages") 
      span.handle {{ message.handle }}:
      span {{ message.body }}

  .grid-item.users
    .user(v-for="user in users") {{ user }}
</template>

<style>
.app
  background: #d4d4d4

.input
  border-radius: 4px
  border: 1px solid #ddd
  padding: 10px
  outline: none
  width: 100%

body
  margin: 0

input, textarea, select
  box-sizing: border-box

.grid-container
  display: grid
  grid-template-columns: auto minmax(auto, 30ch)
  grid-template-rows: auto 40px
  gap: 0px
  height: 100vh
  width: 100%

.grid-item
  border: 1px solid #ccc

.input-wrapper
  grid-column: 1
  grid-row: 2

.messages
  padding: 20px
  grid-column: 1
  grid-row: 1

.users
  padding: 20px
  grid-column: 2
  grid-row: 1 / 2

.handle
  margin-right: 1ch
  color: gray
</style>
