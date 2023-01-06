import { connectStreamSource, disconnectStreamSource } from "@hotwired/turbo"
import { subscribeTo } from "./cable"
import snakeize from "./snakeize"

class TurboCableStreamSourceElement extends HTMLElement {
  declare subscription: Awaited<ReturnType<typeof subscribeTo>>

  async connectedCallback() {
    connectStreamSource(this)
    this.subscription = await subscribeTo(this.channel, { received: this.dispatchMessageEvent.bind(this) })
  }

  disconnectedCallback() {
    disconnectStreamSource(this)
    if (this.subscription) this.subscription.unsubscribe()
  }

  dispatchMessageEvent(data: any) {
    const event = new MessageEvent("message", { data })
    return this.dispatchEvent(event)
  }

  get channel() {
    const channel = this.getAttribute("channel")
    const signed_stream_name = this.getAttribute("signed-stream-name")
    return { channel, signed_stream_name, ...snakeize({ ...this.dataset }) }
  }
}


if (customElements.get("turbo-cable-stream-source") === undefined) {
  customElements.define("turbo-cable-stream-source", TurboCableStreamSourceElement)
}
