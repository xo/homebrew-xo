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

# --------------------------------------------------

# install instantclient-sdk for oracle support -- only needed if using xo/usql
# with oracle databases (see notes below)
$ brew install instantclient-sdk

# install xo with oracle support
$ brew install --with-oracle xo

# install usql with oracle and odbc support
$ brew install --with-oracle --with-odbc usql
```

### Oracle Notes

This is not compatible with the InstantClientTap. Please uninstall it first,
before using the formulae in this repository:

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
