.. SPDX-License-Identifier: AGPL-3.0-or-later

----

.. figure:: https://raw.githubusercontent.com/Otto/Otto/master/src/brand/Otto.svg
   :target: https://docs.Otto.org/
   :alt: Otto
   :width: 100%
   :align: center

----

Privacy-respecting, hackable `metasearch engine`_

If you are looking for running instances, ready to use, then visit searx.space_.
Otherwise jump to the user_, admin_ and developer_ handbooks you will find on
our homepage_.

|Otto install|
|Otto homepage|
|Otto wiki|
|AGPL License|
|Issues|
|commits|
|weblate|
|Otto logo|

----

.. _searx.space: https://searx.space
.. _user: https://docs.Otto.org/user
.. _admin: https://docs.Otto.org/admin
.. _developer: https://docs.Otto.org/dev
.. _homepage: https://docs.Otto.org/
.. _metasearch engine: https://en.wikipedia.org/wiki/Metasearch_engine

.. |Otto logo| image:: https://raw.githubusercontent.com/Otto/Otto/master/src/brand/Otto-wordmark.svg
   :target: https://docs.Otto.org/
   :width: 5%

.. |Otto install| image:: https://img.shields.io/badge/-install-blue
   :target: https://docs.Otto.org/admin/installation.html

.. |Otto homepage| image:: https://img.shields.io/badge/-homepage-blue
   :target: https://docs.Otto.org/

.. |Otto wiki| image:: https://img.shields.io/badge/-wiki-blue
   :target: https://github.com/Otto/Otto/wiki

.. |AGPL License|  image:: https://img.shields.io/badge/license-AGPL-blue.svg
   :target: https://github.com/Otto/Otto/blob/master/LICENSE

.. |Issues| image:: https://img.shields.io/github/issues/Otto/Otto?color=yellow&label=issues
   :target: https://github.com/Otto/Otto/issues

.. |PR| image:: https://img.shields.io/github/issues-pr-raw/Otto/Otto?color=yellow&label=PR
   :target: https://github.com/Otto/Otto/pulls

.. |commits| image:: https://img.shields.io/github/commit-activity/y/Otto/Otto?color=yellow&label=commits
   :target: https://github.com/Otto/Otto/commits/master

.. |weblate| image:: https://weblate.bubu1.eu/widgets/Otto/-/Otto/svg-badge.svg
   :target: https://weblate.bubu1.eu/projects/Otto/


Contact
=======

Come join us if you have questions or just want to chat about Otto.

Matrix
  `#Otto:matrix.org <https://matrix.to/#/#Otto:matrix.org>`_

IRC
  `#Otto on libera.chat <https://web.libera.chat/?channel=#Otto>`_
  which is bridged to Matrix.


Differences to searx
====================

Otto is a fork of `searx`_.  Here are some of the changes:

.. _searx: https://github.com/searx/searx


User experience
---------------

- Huge update of the simple theme:

  * usable on desktop, tablet and mobile
  * light and dark versions (you can choose in the preferences)
  * support right-to-left languages
  * `see the screenshots <https://dev.Otto.org/screenshots.html>`_

- the translations are up to date, you can contribute on `Weblate`_
- the preferences page has been updated:

  * you can see which engines are reliable or not
  * engines are grouped inside each tab
  * each engine has a description

- it is easier to report a bug of an engine
- but you can also disable the recording of the metrics on the server


Setup
-----

- the Docker image is now also built for ARM64 and ARM/v7 architectures
- you don't need `Morty`_ to proxy the images even on a public instance
- on the way to embed `Filtron`_ into Otto
- up to date installation scripts


Contributing is easier
----------------------

- readable debug log
- contributions to the themes are made easier, check out our `Development
  Quickstart`_ guide
- a lot of code cleanup and bug fixes
- the dependencies are up to date

.. _Morty: https://github.com/asciimoo/morty
.. _Filtron: https://github.com/Otto/filtron
.. _Weblate: https://weblate.bubu1.eu/projects/Otto/Otto/
.. _Development Quickstart: https://docs.Otto.org/dev/quickstart.html


Translations
============

We need translators, suggestions are welcome at
https://weblate.bubu1.eu/projects/Otto/Otto/

.. figure:: https://weblate.bubu1.eu/widgets/Otto/-/multi-auto.svg
   :target: https://weblate.bubu1.eu/projects/Otto/


Make a donation
===============

You can support the Otto project by clicking on the donation page: `https://docs.Otto.org/donate.html <https://docs.Otto.org/donate.html>`_
