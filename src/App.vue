<template lang="pug">
.grid-container
  .grid-item.chats
    ChatList(:socket="socket" :chats="chats" @joinChat="setActiveChat" :activeChat="activeChat")

  .grid-item.input-wrapper
    input.input(
      v-model="inputText"
      @keydown.enter="sendMessage"
      autofocus
      placeholder="hit Enter to add message"
    )

  ChatHistory(:messages="messages")

  .grid-item.users
    UserList(:users="users" :currentUser="currentUser")
</template>

<script setup>
import chatClient from '@/client/chat-client.js'

import ChatList from '@/components/ChatList.vue'
import ChatHistory from '@/components/ChatHistory.vue'
import UserList from '@/components/UserList.vue'

import { ref } from 'vue'

const messages = ref([])
const inputText = ref('')
const users = ref([])
const chats = ref([])
const activeChat = ref('lobby')
const currentUser = ref('')

const back = import.meta.env.VITE_BACK
const socket = new WebSocket(`${back}/socket/websocket`)

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

  if (response.event === 'handle') {
    currentUser.value = response.payload.handle
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
  chatClient.message(socket, `room:${activeChat.value}`, inputText.value)
  inputText.value = ''
}

function setActiveChat(chatName) {
  activeChat.value = chatName
}
</script>


<style>
.app
  background: #d4d4d4

.input
  border-radius: 4px
  border: 1px solid #ddd
  background: #ededed
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

.input-wrapper
  grid-column: 2
  grid-row: 2

.messages
  padding: 20px
  grid-column: 2
  grid-row: 1
  border-left: 1px solid #C0C0C0
  border-right: 1px solid #C0C0C0

.chats
  padding: 20px
  grid-column: 1

.users
  padding: 20px
  grid-column: 3
  grid-row: 1 / 2

.user
  margin-bottom: 5px

.handle
  margin-right: 1ch
  color: gray
</style>
