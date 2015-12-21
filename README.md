homebrew-ecell4
===============

## Mac OS X

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap ecell/ecell4
brew install ecell4
```

## Ubuntu Linux

```shell
sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev python-dev python-setuptools
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
brew tap ecell/ecell4
brew install ecell4
```

## CentOS Linux

```shell
sudo yum groupinstall 'Development Tools'
sudo yum install curl git m4 ruby texinfo bzip2-devel curl-devel expat-devel ncurses-devel zlib-devel python-devel python-setuptools
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
ln -s `which gcc` `brew --prefix`/bin/gcc-4.8
ln -s `which g++` `brew --prefix`/bin/g++-4.8
brew tap ecell/ecell4
brew install ecell4
```

## how to import ecell4 in Python interactive shell

```
python
>>> from ecell4 import *
```
