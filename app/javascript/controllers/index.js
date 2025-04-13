// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Custom Turbo Stream Actions
import { StreamActions } from "controllers/custom_stream_actions";
Object.assign(Turbo.StreamActions, StreamActions)
