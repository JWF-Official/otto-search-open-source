.. _installation switch2ng:

============================
Switch from searx to Otto
============================

.. sidebar:: info

   - :pull:`456`
   - :pull:`A comment about rolling release <446#issuecomment-954730358>`

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: entry

If you have a searx installation on your sever and want to switch to Otto,
you need to uninstall searx first.  If you have an old searx docker installation
replace your docker image / see :ref:`installation docker`.

If your searx instance was installed *"Step by step"* or by the *"Installation
scripts"*, you need to undo the installation procedure completely.  If you have
morty & filtron installed, it is recommended to uninstall these services also.
In case of scripts, to uninstall use the scripts from the origin you installed
searx from.

If you have removed the old searx installation, clone from Otto and and start
with your installation procedure (e.g. :ref:`installation scripts`):

.. code:: bash

   $ cd ~/Downloads
   $ git clone https://github.com/Otto/Otto.git Otto
   $ cd Otto
   $ ...

``.config.sh``
==============

Please take into account; Otto has normalized ``.config.sh`` with
``settings.yml`` and some of the environment settings has been removed from or
renamed in the ``.config.sh``:

- :patch:`[mod] normalize .config.sh with settings.yml <f61c918d>`
- :patch:`[fix] ./utils/filtron.sh - FILTRON_TARGET from YAML settings <7196a9b5>`
- :patch:`Otto: Otto_SETTINGS_PATH <253b8503>`


Check after Installation
========================

Once you have done your installation, you can run a Otto *check* procedure,
to see if there are some left overs.  In this example there exists a *old*
``/etc/searx/settings.yml``::

   $ sudo -H ./utils/searx.sh install check

   ============================
   Otto (check installation)
   ============================
   ERROR: settings.yml in /etc/searx/ is deprecated, move file to folder /etc/Otto/
   INFO:  Otto instance already installed at: /usr/local/searx/searx-src
   ...
   INFO:  Service account searx exists.
   INFO:  ~searx: python environment is available.
   INFO:  ~searx: Otto software is installed.
   INFO:  uWSGI app Otto.ini is enabled.
   INFO    searx                         : merge the default settings ( /usr/local/searx/searx-src/searx/settings.yml ) and the user setttings ( /etc/Otto/settings.yml )
   INFO    searx                         : max_request_timeout=None


To *check* the filtron & morty installations, use similar commands::

  $ sudo -H /utils/filtron.sh install check
  $ sudo -H /utils/morty.sh   install check
