import {connectStreamSource, disconnectStreamSource} from "@hotwired/turbo"
import {subscribeTo} from "./cable"
import snakeize from "./snakeize"

class TurboCableStreamSourceElement extends HTMLElement {
  static observedAttributes = ["channel", "signed-stream-name"]

  constructor() {
    super()
    this.beforeTurboRender = this.beforeTurboRender.bind(this)
    this.afterTurboRender = this.afterTurboRender.bind(this)
  }

  async connectedCallback() {
    document.addEventListener("turbo:before-render", this.beforeTurboRender)
    document.addEventListener("turbo:render", this.afterTurboRender)

    if (!this.withinTurboRender) {
      await this.subscribe()
    }
  }

  async disconnectedCallback() {
    document.removeEventListener("turbo:before-render", this.beforeTurboRender)
    document.removeEventListener("turbo:render", this.afterTurboRender)

    if (!this.withinTurboRender) {
      this.unsubscribe()
    }
  }

  async attributeChangedCallback() {
    if (this.subscription) {
      this.unsubscribe()
      await this.subscribe()
    }
  }

  async subscribe() {
    connectStreamSource(this)
    this.subscription = await subscribeTo(this.channel, {
      received: this.dispatchMessageEvent.bind(this),
      connected: this.subscriptionConnected.bind(this),
      disconnected: this.subscriptionDisconnected.bind(this)
    })
  }

  unsubscribe() {
    disconnectStreamSource(this)
    if (this.subscription) this.subscription.unsubscribe()
    this.subscriptionDisconnected()
  }

  dispatchMessageEvent(data) {
    const event = new MessageEvent("message", { data })
    return this.dispatchEvent(event)
  }

  subscriptionConnected() {
    this.setAttribute("connected", "")
  }

  subscriptionDisconnected() {
    this.removeAttribute("connected")
  }

  beforeTurboRender() {
    this.withinTurboRender = true;
  }

  afterTurboRender() {
    if (this.withinTurboRender && !this.isConnected) {
      this.unsubscribe();
    }
    this.withinTurboRender = false;
  }

  get channel() {
    const channel = this.getAttribute("channel")
    const signed_stream_name = this.getAttribute("signed-stream-name")
    return {channel, signed_stream_name, ...snakeize({...this.dataset})}
  }
}


if (customElements.get("turbo-cable-stream-source") === undefined) {
  customElements.define("turbo-cable-stream-source", TurboCableStreamSourceElement)
}
