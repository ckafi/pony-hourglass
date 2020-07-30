# pony-hourglass

A IS0 8601 conform, time zone aware date and time package for pony

## Status

[![CircleCI](https://circleci.com/gh/ckafi/pony-hourglass.svg?style=svg)](https://circleci.com/gh/ckafi/pony-hourglass)

pony-hourglass is pre-alpha software.

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{
  "type": "github",
  "repo": "ckafi/pony-hourglass"
}
```

* `stable fetch` to fetch your dependencies
* `use "hourglass"` to include this package
* `stable env ponyc` to compile your application
