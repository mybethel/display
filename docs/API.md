Render API
===

The render API is used by Bethel Display to control the various layers being
shown. When running Display on Mac OS X, the display server is run on the host
system and can be accessed at `http://localhost:1776`

The following layers are available in order of front to rear:

- HTML: Used for lyrics and text-based slides
- Graphic: Full screen images or static backgrounds
- Video: Both looped and non-looped video playback

Along with the documented endpoints, the following headers can be used to
configure parameters on all requests:

- `transitionSpeed`: Time in milliseconds to transition the layer from it's
  previous content to the new content. Default: `0`.

Toggle
---

Functions as a "fade to black" when content is visible. Removes all layers from
display and returns the display to it's configured background color. Run again
when the display is hidden will return all previously visible layers to shown.

* **URL:** `/render/toggle`

* **Method:** `POST`

* **Response:**

  A boolean representing the visibility of the display.

HTML
---

Renders a string as an HTML document on the upper-most display layer. The
background of the layer is transparent so anything not explicitly colored in
the markup will show through to any below layers with content.

This API endpoint is used to render lyrics and text-based slides.

* **URL:** `/render/html`

* **Method:** `POST`

* **Params:**

  The body of the request should be a complete HTML string rendered by WebKit.
  Styles should be inlined and all resources must be converted to Base64.

Graphic
---

Renders the graphic file at the provided path in full screen mode. Any alpha
channel in the graphic is respected and will show through to lower layers.

* **URL:** `/render/graphic`

* **Method:** `POST`

* **Params:**

  The body of the request should be a path to the graphic file on the host.
  Tilde's are supported to alias the current user's home directory.
