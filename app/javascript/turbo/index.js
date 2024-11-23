import "./cable_stream_source_element"

import * as Turbo from "@hotwired/turbo"
export { Turbo }

import * as cable from "./cable"
export { cable }

import { encodeMethodIntoRequestBody } from "./fetch_requests"

/**
 * Call `Turbo.visit(location)`, where `location` is read from the
 * `<turbo-stream>` element's `[location]` attribute.
 */
Turbo.StreamActions.visit = function() {
  Turbo.visit(this.getAttribute("location"))
}

window.Turbo = Turbo

addEventListener("turbo:before-fetch-request", encodeMethodIntoRequestBody)
