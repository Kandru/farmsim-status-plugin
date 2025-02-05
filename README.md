# Farming Simulator 25 - Status Plugin

[![GitHub release](https://img.shields.io/github/release/Kandru/farmsim-status-plugin?include_prereleases=&sort=semver&color=blue)](https://github.com/Kandru/farmsim-status-plugin/releases/)
[![License](https://img.shields.io/badge/License-GPLv3-blue)](#license)
[![issues - farmsim-status-plugin](https://img.shields.io/github/issues/Kandru/farmsim-status-plugin?color=darkgreen)](https://github.com/Kandru/farmsim-status-plugin/issues)
[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=C2AVYKGVP9TRG)

![Farming Simulator Status Plugin Logo](https://github.com/Kandru/farmsim-status-plugin/blob/main/icon.jpg?raw=true)

This plugin offers a detailed overview of your Farming Simulator 25 server directly from your web browser. It includes two main components: a LUA plugin and a Python script. The LUA plugin collects data regularly and writes it to an XML file. The Python script reads this file and generates a regularly updated website.

See https://github.com/kandru/farmsim-status-gui for more information about the GUI.

## Road Map

- [X] Get Mission Information
- [X] Get Player Information
- [X] Get Farm Information
- [ ] Get Player Positions
- [ ] Get Vehicle Positions
- [ ] Get Stationary Building Positions
- [X] Get Farmlands

## Plugin Installation (automatic)

Coming soon

## Plugin Installation / Update (manual)

1. Download and extract the latest release from the [GitHub releases page](https://github.com/Kandru/farmsim-status-plugin/releases/)
2. Move the .zip file into your mods directory like every other mod on both server and client
3. Restart game / server

## Development

- Fork this repository
- Make desired code changes
- Check code changes with the official TestRunner tool: https://forum.giants-software.com/viewtopic.php?t=187502
- Create a pull request on GitHub

## Other useful stuff used for debugging purposes

- FS25 data dump https://github.com/w33zl/FS25_DataDump
- FS25 Modding Guidelines https://forum.giants-software.com/viewtopic.php?t=209170
- FS25 TestRuner Tool https://forum.giants-software.com/viewtopic.php?t=187502
- FS22 Lua Doc https://gdn.giants-software.com/documentation_scripting_fs22.php

## License

Released under [GPLv3](/LICENSE) by [@Kandru](https://github.com/Kandru).

## Authors

- [@derkalle4](https://www.github.com/derkalle4)
