#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

git config --global push.default current
git config --global user.name {name}
git config --global user.email {email}
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.fh fetch
git config --global alias.pl pull
git config --global alias.ph push
