import "./cable_stream_source_element"
import { overrideMethodWithFormmethod } from "./form_submissions"

import * as Turbo from "@hotwired/turbo"
export { Turbo }

import * as cable from "./cable"
export { cable }

addEventListener("turbo:submit-start", overrideMethodWithFormmethod)
