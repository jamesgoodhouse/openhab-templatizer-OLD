# openHAB Templatizer

This is an attempt to extend the [openhab-docker](https://github.com/openhab/openhab-docker) image to allow for parsing of templatized configuration files. This is mostly handy for drying up common values shared across config files (e.g., thing ids) or for pulling secrets out of configuration, thus allow config files to be more broadly shared in public repositories.

## To-Dos

* Trigger rebuild of templates when configs/secrets YAMLs change
* Run watchman as its own user
* Look into what to do if a `.tmpl` is removed. Should an attempt be made to remove its generated config file that's now left behind?
* Update `parse-templates` script to make use of the changes files that are passed to it via watchman so it only rebuilds what's needed.
