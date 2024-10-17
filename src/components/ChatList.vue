<script setup>
import chatClient from '@/client/chat-client.js'
import { ref } from 'vue'

const props = defineProps({
  socket: Object,
  chats: Array
});

const chatName = ref('')

function createChat() {
  chatClient.create(props.socket, "room:lobby", chatName.value)
  chatName.value = ''
}
</script>

<template lang=pug>
.chat-list
  .chat(v-for="chat in chats" :key="chat.id") {{ chat.name }}

  input.chat-name(v-model="chatName" @keydown.enter="createChat")
</template>

<style>
</style>
