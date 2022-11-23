import type {
  Consumer,
  Mixin,
  createConsumer as ActionCableCreateConsumer,
  ChannelNameWithParams
} from '@rails/actioncable'

let consumer: Consumer | undefined

export async function getConsumer() {
  return consumer || setConsumer(await createConsumer())
}

export function setConsumer(newConsumer: Consumer) {
  return consumer = newConsumer
}

export async function createConsumer() {
  const { createConsumer } = await import(/* webpackChunkName: "actioncable" */ "@rails/actioncable")
  return (createConsumer as (typeof ActionCableCreateConsumer))()
}

export async function subscribeTo<M>(channel: string | ChannelNameWithParams, mixin?: Mixin & M) {
  const { subscriptions } = await getConsumer()
  return subscriptions.create(channel, mixin)
}
