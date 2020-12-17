let consumer

export async function getConsumer() {
  if (consumer) return consumer
  const { createConsumer } = await import("@rails/actioncable/src")
  return setConsumer(createConsumer())
}

export function setConsumer(newConsumer) {
  return consumer = newConsumer
}

export async function subscribeTo(channel, mixin) {
  const { subscriptions } = await getConsumer()
  return subscriptions.create(channel, mixin)
}
