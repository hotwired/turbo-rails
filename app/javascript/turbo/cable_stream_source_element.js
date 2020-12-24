import { connectStreamSource, disconnectStreamSource } from "@hotwired/turbo"
import { subscribeTo } from "./cable"

class TurboCableStreamSourceElement extends HTMLElement {
  async connectedCallback() {
    connectStreamSource(this)
    this.subscription = await subscribeTo(this.channel, { received: this.dispatchMessageEvent.bind(this) })
  }

  disconnectedCallback() {
    disconnectStreamSource(this)
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
}

customElements.define("turbo-cable-stream-source", TurboCableStreamSourceElement)
