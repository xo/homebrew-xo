# About homebrew-xo

Homebrew formulas for [xo](https://github.com/xo/xo) and [usql](https://github.com/xo/usql).

## Installation

Use in the usual way with Homebrew:

```sh
# add tap
$ brew tap xo/xo

# install xo
$ brew install xo

# install usql with "most" drivers
$ brew install usql

# install instantclient-sdk for oracle support (see note below)
$ brew install instantclient-sdk

# install usql with oracle and odbc support
$ brew install --with-oracle --with-odbc usql
```

### Oracle Notes

This is not compatible with the InstantClientTap. Please uninstall it first,
before using the formulae in this repository:

```sh
# uninstall the instantclient-sdk formula
$ brew uninstall InstantClientTap/instantclient/instantclient-sdk

# untap
$ brew untap InstantClientTap/instantclient
```
