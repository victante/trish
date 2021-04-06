<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

#### trish
> A plugin for [Oh My Fish][omf-link].

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v3.0.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>


## Install

### OMF

```fish
$ omf install https://github.com/victante/trish
```

If/when OMF maintainers approve this package on their repo, it will be easier to install:

```fish
$ omf install trish
```

### Fisher

```fish
$ fisher install victante/trish
```

### Fundle

Insert `fundle plugin 'victante/trish'` in your config.fish, before the `fundle init` line. Reload the shell and then run:

```fish
$ fundle install
```

### Manual installation

```fish
$ git clone https://github.com/victante/trish
$ mv trish/functions/* ~/.config/fish/functions
```


## Usage

```fish
$ trish ITEMS # send ITEMS to the trash
$ trishl # list what's in the trash
$ trishl [-p INT/--peek INT/-INT] # list the contents of the deleted folder of index INT
$ trishc # enter interactive mode for cleaning the trash
$ trishc [-a/--all] # clean the entire trash folder at once
$ trishc [-o INT/--old INT/-INT] # clean all files that were in the trash for INT days or more
$ trishr # enter interactive mode for restoring items from the trash
$ trishr [-a/--all] # restore all items from the trash
```

All 4 functions also have a '-h/--help' flag to display a nice little help text.


## The name

'Trish' is a mashup of 'trash' and 'fish'. Kinda obvious, but I'm personally very proud of it.


# License

[MIT][mit] © [Victor Coutinho][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/{{USER}}
[contributors]:   https://github.com/{{USER}}/plugin-trish/graphs/contributors
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
