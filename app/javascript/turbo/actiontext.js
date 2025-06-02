import { observeAttributes } from "./util"

export function observeTurboAttributes({ target }) {
  observeAttributes(target, ["data-turbo-permanent"], (value) => {
    if (target.inputElement) {
      target.inputElement.toggleAttribute("data-turbo-permanent", value ?? false)
    }
  })
}
