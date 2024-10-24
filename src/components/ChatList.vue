<template lang="pug">
.chat-list
  .chat(v-for="chat in chats" :key="chat.id") {{ chat.name }}

  input.input.chat-name(
      v-model="chatName"
      @keydown.enter="createChat"
      placeholder="hit Enter to create chat"
    )
</template>

<script setup>
import chatClient from '@/client/chat-client.js'
import { ref } from 'vue'

const props = defineProps({
  socket: Object,
  chats: Array
});

const chatName = ref('')

function createChat() {
  if (chatName.value === '') {
    alert("Please enter a chat name.")
    return;
  }

  chatClient.create(props.socket, "room:lobby", chatName.value)
  chatName.value = ''
}
</script>

<style lang="sss">
.chat
  margin-bottom: 5px

.chat-name
  width: 100%
</style>
