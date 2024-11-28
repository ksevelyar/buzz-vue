<template lang="pug">
.chat-list
  .chat(
    v-for="chat in chats"
    :class="{'chat--active': chat === props.activeChat}"
    :key="chat"
    @click="joinChat(chat)"
  ) {{ chat }}

  input.input.chat-name(
    v-model.trim="chatName"
    @keydown.enter="createChat"
    placeholder="hit Enter to create chat"
  )
</template>

<script setup>
import chatClient from '@/client/chat-client.js'
import { ref } from 'vue'

const emit = defineEmits(['joinChat'])
const props = defineProps({
  socket: Object,
  chats: Array,
  activeChat: String
});

const chatName = ref('')

function createChat() {
  if (chatName.value === '') return;

  chatClient.create(props.socket, "room:lobby", chatName.value)
  joinChat(chatName.value)

  chatName.value = ''
}

function joinChat(name) {
  chatClient.join(props.socket, `room:${name}`)

  emit('joinChat', name)
}
</script>

<style lang="sss">
.chat
  margin-bottom: 5px
  cursor: pointer

.chat--active
  color: #7435ff

.chat-name
  width: 100%
</style>
