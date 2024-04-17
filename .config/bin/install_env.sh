#!/bin/bash

####################################################################################
# Install Homebrew
####################################################################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew doctor

####################################################################################
# Install oh-my-zsh
####################################################################################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

####################################################################################
# APPS
####################################################################################
brew install git
brew install --cask google-chrome
brew install --cask slack
brew install --cask recordit
brew install --cask iterm2
brew cask install alacritty
brew install --cask zoom
# brew install --cask postman
# Screen color temperature controller. To have night shift in 2 external monitors
brew install --cask flux
# Screen capturer suggested by pechito
# brew install --cask kap

brew install --cask brave-browser
brew install --cask obsidian
brew install --cask amethyst
brew install --cask docker
brew install --cask spotify
# MySql Client
brew install --cask mysqlworkbench
# Postgres Client
brew install --cask dbeaver-community

# QMK Toolbox to flush Corne Keyboard Image
# Seems tap is not working, just in case it can be downloaded from:
# https://github.com/qmk/qmk_toolbox/releases
# brew tap homebrew/cask-driver
# brew install --cask qmk-toolbox

# Install neovim and some dependencies
brew install neovim
brew install rust
brew install ripgrep
brew install lazygit
# Install lunarvim
brew install fd
brew install fzf
brew install yq
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

# Install TMUX
brew install tmux

# NerdFonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font


####################################################################################
# XCode command line tool
####################################################################################
# https://mac.install.guide/commandlinetools/index.html
# xcode-select --install # Only Command Line Tools
# xcode-select -p # Checks if ok. Result example: /Library/Developer/CommandLineTools


####################################################################################
####################################################################################
# Git Configuration
####################################################################################
# git config --global user.name "Your name"
# git config --global user.email your_name@optoro.com
# git config --global push.default current
# git config --global color.ui true
# git config --global color.diff.whitespace "red reverse"
# git config -l --global

####################################################################################
# Install NVM
####################################################################################
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.7/install.sh | bash
source ~/.profile # run this command to grab the latest changes
# Install Node.js
nvm install --lts # to install the LTS version of Node
# Use or download version in .nvmrc
nvm use

# Install ttab to open iTerm2 tabs from bash scripts
# npm install -g ttab

####################################################################################
# Install RVM
####################################################################################
# See http://rvm.io/rvm/install for other ways
curl -sSL https://get.rvm.io | bash
# Reload rvm
rvm reload
source ~/.profile

# Run rvm requirements to install various packages required to compile Ruby and native extensions.
# This is a little scary because it actually installs the stuff, rather than simply telling you what you need. But whatever, it works.
rvm requirements
