customElements.define("turbo-stream-from", class extends HTMLElement {
  async connectedCallback() {
    Turbo.connectStreamSource(this)
    this.subscription = await subscribeTo(this.channel, { received: this.dispatchMessageEvent.bind(this) })
  }

  disconnectedCallback() {
    Turbo.disconnectStreamSource(this)
    if (this.subscription) this.subscription.unsubscribe()
  }

  dispatchMessageEvent(data) {
    const event = new MessageEvent("message", { data })
    return this.dispatchEvent(event)
  }

  get channel() {
    const channel = this.getAttribute("channel")
    const signed_stream_name = this.getAttribute("signed-stream-name")
    return { channel, signed_stream_name }
  }
})

async function subscribeTo(channel, mixin) {
  const consumer = await getConsumer()
  return consumer.subscriptions.create(channel, mixin)
}

async function getConsumer() {
  if (!getConsumer.instance) {
    const { createConsumer } = await loadActionCable()
    getConsumer.instance = createConsumer()
  }
  return getConsumer.instance
}

async function loadActionCable() {
  const attribute = "data-action-cable-src"
  const element = document.head.querySelector(`[${attribute}]`)
  return await import(element.getAttribute(attribute))
}
