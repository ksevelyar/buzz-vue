<script setup>
import HelloWorld from './components/HelloWorld.vue'

const socketUrl = "ws://localhost:4000/socket/websocket"

const socket = new WebSocket(socketUrl)

function joinTopic(topic, payload = {}) {
  socket.onopen = () => {
    const joinMessage = {
      topic: topic,
      event: "phx_join",
      payload: payload,
      ref: 1
    }

    socket.send(JSON.stringify(joinMessage))

    console.log(`Attempting to join topic: ${topic}`)

    sendMessage("room:lobby", "shout", { body: "Hello from the client!" })
  }

  socket.onmessage = (event) => {
    const message = JSON.parse(event.data)
    console.log("Received message:", message)
  }

  socket.onerror = (error) => {
    console.error("WebSocket error:", error)
  }

  socket.onclose = (event) => {
    console.log("WebSocket closed:", event)
  }
}

function sendMessage(topic, event, payload = {}) {
  const message = {
    topic: topic,     // Topic to send the message to (e.g., "room:lobby")
    event: event,     // The custom event, e.g., "new_message"
    payload: payload, // The payload containing your data
    ref: 2            // Reference for the message
  }

  // Send the message
  socket.send(JSON.stringify(message))
  console.log(`Sent message: ${event} with payload:`, payload)
}

joinTopic("room:lobby", { user_id: 123 })


</script>

<template lang="pug">
.messages

input(placeholder="message")
</template>

<style>
</style>
