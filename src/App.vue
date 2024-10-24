<script setup>
import chatClient from '@/client/chat-client.js'

import ChatList from '@/components/ChatList.vue'
import { ref } from 'vue'

const messages = ref([])
const inputText = ref('')
const users = ref([])
const chats = ref([])

const socket = new WebSocket('ws://localhost:4001/socket/websocket')

socket.onopen = () => {
  chatClient.join(socket, "room:lobby")
}

socket.onmessage = (event) => {
  const response = JSON.parse(event.data)
  console.log(response)

  if (response.event === 'shout') {
    messages.value.push(response.payload)
  }

  if (response.event === 'user_list') {
    users.value = response.payload.users
  }

  if (response.event === 'chat_list') {
    chats.value = response.payload.chats
  }

  if (response.event === 'messages_list') {
    messages.value = response.payload.messages
  }
}

socket.onerror = (error) => {
  console.error("WebSocket error:", error)
}

socket.onclose = (event) => {
  console.log("WebSocket closed:", event)
}

function sendMessage() {
  chatClient.message(socket, "room:lobby", inputText.value)
  inputText.value = ''
}
</script>

<template lang="pug">
.grid-container
  .grid-item.chats
    ChatList(:socket="socket" :chats="chats")

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
  grid-template-columns: minmax(auto, 30ch) auto minmax(auto, 30ch)
  grid-template-rows: auto 40px
  gap: 0px
  height: 100vh
  width: 100%

.grid-item
  border: 1px solid #ccc

.input-wrapper
  grid-column: 2
  grid-row: 2

.messages
  padding: 20px
  grid-column: 2
  grid-row: 1

.chats
  padding: 20px
  grid-column: 1

.users
  padding: 20px
  grid-column: 3
  grid-row: 1 / 2

.handle
  margin-right: 1ch
  color: gray
</style>
