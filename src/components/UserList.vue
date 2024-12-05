<template lang="pug">
.user-list
  .user(
    v-for="user in users"
    :class="{'user--active': user === props.currentUser}"
    :key="user"
  ) {{ user }}
</template>

<script setup>
const props = defineProps({
  users: Array,
  currentUser: String
});
</script>

<style lang="sss">
.user--active
  color: #7435ff
</style>
