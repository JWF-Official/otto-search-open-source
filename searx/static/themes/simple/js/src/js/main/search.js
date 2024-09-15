/* SPDX-License-Identifier: AGPL-3.0-or-later */
/* global AutoComplete */
(function (w, d, Otto) {
  'use strict';

  var qinput_id = "q", qinput;

  const isMobile = window.matchMedia("only screen and (max-width: 50em)").matches;

  function submitIfQuery () {
    if (qinput.value.length  > 0) {
      var search = document.getElementById('search');
      setTimeout(search.submit.bind(search), 0);
    }
  }

  function createClearButton (qinput) {
    var cs = document.getElementById('clear_search');
    var updateClearButton = function () {
      if (qinput.value.length === 0) {
        cs.classList.add("empty");
      } else {
        cs.classList.remove("empty");
      }
    };

    // update status, event listener
    updateClearButton();
    cs.addEventListener('click', function (ev) {
      qinput.value = '';
      qinput.focus();
      updateClearButton();
      ev.preventDefault();
    });
    qinput.addEventListener('keyup', updateClearButton, false);
  }

  Otto.ready(function () {
    qinput = d.getElementById(qinput_id);

    if (qinput !== null) {
      // clear button
      createClearButton(qinput);

      // autocompleter
      if (Otto.settings.autocomplete_provider) {
        Otto.autocomplete = AutoComplete.call(w, {
          Url: "./autocompleter",
          EmptyMessage: Otto.settings.translations.no_item_found,
          HttpMethod: Otto.settings.http_method,
          HttpHeaders: {
            "Content-type": "application/x-www-form-urlencoded",
            "X-Requested-With": "XMLHttpRequest"
          },
          MinChars: Otto.settings.autocomplete_min,
          Delay: 300,
          _Position: function () {},
          _Open: function () {
            var params = this;
            Array.prototype.forEach.call(this.DOMResults.getElementsByTagName("li"), function (li) {
              if (li.getAttribute("class") != "locked") {
                li.onmousedown = function () {
                  params._Select(li);
                };
              }
            });
          },
        }, "#" + qinput_id);
      }

      if (!isMobile && document.querySelector('.index_endpoint')) {
        qinput.focus();
      }
    }

    // vanilla js version of search_on_category_select.js
    if (qinput !== null && d.querySelector('.help') != null && Otto.settings.search_on_category_select) {
      d.querySelector('.help').className = 'invisible';

      Otto.on('#categories input', 'change', function () {
        var i, categories = d.querySelectorAll('#categories input[type="checkbox"]');
        for (i = 0; i < categories.length; i++) {
          if (categories[i] !== this && categories[i].checked) {
            categories[i].click();
          }
        }
        if (! this.checked) {
          this.click();
        }
        submitIfQuery();
        return false;
      });

      Otto.on(d.getElementById('safesearch'), 'change', submitIfQuery);
      Otto.on(d.getElementById('time_range'), 'change', submitIfQuery);
      Otto.on(d.getElementById('language'), 'change', submitIfQuery);
    }

  });

})(window, document, window.Otto);
