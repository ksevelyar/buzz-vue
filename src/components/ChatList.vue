<script setup>
import chatClient from '@/client/chat-client.js'
import { ref } from 'vue'

const props = defineProps({
  socket: Object
});

const chats = ref([])
const chatName = ref('')

function createChat() {
  chatClient.create(props.socket, "room:lobby", chatName.value)
  chatName.value = ''
}

props.socket.onmessage = (event) => {
  const response = JSON.parse(event.data)

  if (response.event === 'new_chat') {
    console.log(response)
  }
}
</script>

<template lang=pug>
.chat-list
  .chat(v-for="chat in chats" :key="chat.id")

  input.chat-name(v-model="chatName" @keydown.enter="createChat")
</template>

<style>
</style>
