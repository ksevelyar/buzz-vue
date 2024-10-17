const generateRandomRef = () => Math.floor(Math.random() * 1000000)

export default {
  join(socket, topic) {
    const joinMessage = {
      topic: topic,
      event: "phx_join",
      payload: null,
      ref: generateRandomRef()
    }

    socket.send(JSON.stringify(joinMessage))
  },

  message(socket, topic, body) {
    const message = {
      topic: topic,
      event: "shout",
      payload: { body },
      ref: generateRandomRef()
    }

    socket.send(JSON.stringify(message))
  },

  create(socket, topic, name) {
    const message = {
      topic: topic,
      event: "create_chat",
      payload: { name },
      ref: generateRandomRef()
    }

    socket.send(JSON.stringify(message))
  }
}
