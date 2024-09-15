/* SPDX-License-Identifier: AGPL-3.0-or-later */
(function (w, d, Otto) {
  'use strict';

  if (Otto.endpoint !== 'preferences') {
    return;
  }

  Otto.ready(function () {
    let engine_descriptions = null;
    function load_engine_descriptions () {
      if (engine_descriptions == null) {
        Otto.http("GET", "engine_descriptions.json").then(function (content) {
          engine_descriptions = JSON.parse(content);
          for (const [engine_name, description] of Object.entries(engine_descriptions)) {
            let elements = d.querySelectorAll('[data-engine-name="' + engine_name + '"] .engine-description');
            for (const element of elements) {
              let source = ' (<i>' + Otto.settings.translations.Source + ':&nbsp;' + description[1] + '</i>)';
              element.innerHTML = description[0] + source;
            }
          }
        });
      }
    }

    for (const el of d.querySelectorAll('[data-engine-name]')) {
      Otto.on(el, 'mouseenter', load_engine_descriptions);
    }
  });
})(window, document, window.Otto);
