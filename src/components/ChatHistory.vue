<template lang="pug">
.grid-item.messages
  .message(v-for="message in messages")
    span.handle {{ message.handle }}:
    span {{ message.body }}
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  messages: Array
});
</script>
