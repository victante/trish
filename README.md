<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

#### trish
> A plugin for [Oh My Fish][omf-link].

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v3.0.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>


## Install

It will be possible to install with

```fish
$ omf install trish
```

...after I request OMF maintainers to add trish to their repos. For now, I'd recommend manually putting the files in your fish functions folder:

```fish
$ wget https://github.com/victante/trish
$ mv trish/functions/* ~/.config/fish/functions
```


## Usage

```fish
$ trish
```


## Missing parts

These still need to be implemented:

- The whole trishr function (to restore files from the trash);
- The help argument in each function;
- This Readme file, explaining how to use each function.

These are already working:

- trish function (to put files in the trash);
- trishl function (to list what's in the trash);
- trishc function (to clear the trash, or parts of it).


## The name

'Trish' is a mashup of 'trash' and 'fish'. Kinda obvious, but I'm personally very proud of it.


# License

[MIT][mit] © [Victor Coutinho][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/{{USER}}
[contributors]:   https://github.com/{{USER}}/plugin-trish/graphs/contributors
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
