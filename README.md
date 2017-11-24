# About homebrew-xo

Provides Homebrew formulas for [xo](https://github.com/xo/xo),
[usql](https://github.com/xo/usql), and a pkg-config'urable version of Oracle
InstantClient.

## Installing

Install and use in the normal way with Homebrew:

```sh
# add tap
$ brew tap xo/xo

# install xo
$ brew install xo

# install usql with "most" drivers
$ brew install usql

# install xo with oracle support
$ brew install --with-oracle xo

# install usql with oracle and odbc support
$ brew install --with-oracle --with-odbc usql
```

### Oracle Notes

Oracle database support for `xo` and `usql` can be enabled by passing the
`--with-oracle` option during install or upgrade. Please note, however, that
the `xo` and `usql` formulae contained in this repository are not compatible
with the InstantClientTap/instantclient/instantclient-* formulae.

Please uninstall that tap and any installed formulae first before installing
the `xo` or `usql` formulae:

```sh
# uninstall the instantclient-sdk formula
$ brew uninstall InstantClientTap/instantclient/instantclient-sdk

# remove conflicting tap
$ brew untap InstantClientTap/instantclient
```

## Uninstalling

Uninstall in the usual way with Homebrew:

```sh
# uninstall xo
$ brew uninstall xo

# uninstall usql
$ brew uninstall usql

# remove tap
$ brew untap xo/xo
```

## Upgrading

Upgrade in the usual way with Homebrew:

```sh
# upgrade formulae
$ brew upgrade

# upgrade xo
$ brew upgrade xo

# upgrade usql
$ brew upgrade usql

# upgrade xo / usql with oracle and odbc support (see oracle installation notes above)
$ brew upgrade --with-oracle xo
$ brew upgrade --with-oracle --with-odbc usql
```
