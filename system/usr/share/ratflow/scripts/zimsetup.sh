#!/bin/bash

if ! which zsh; then
  sudo apt install -y zsh
else
  echo "zsh already installed, skipping"
fi

cd $HOME
if [ -f .zshrc ]; then
  echo ".zshrc already present, skipping"
else
  cp /usr/share/ratflow/app_configs/zshrc $HOME/.zshrc
fi

if [ -f .zimrc ]; then
  echo ".zimrc already present, skipping"
else
  wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  cp /usr/share/ratflow/app_configs/zimrc $HOME/.zimrc
fi

if [ -f .zsh_history ]; then
  echo ".zsh_history already present, skipping"
else
  echo "Importing history from bash"
  timestamp=$(date +%s):0

  while IFS= read -r line; do
      echo ": $timestamp:0;$line" >> ~/.zsh_history
  done < ~/.bash_history
fi

if [ ! -d .fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

echo -e "\nDone!\n"
echo -e "To change default shell, run:"
echo -e "  chsh -s $(which zsh)\n"
echo -e "To use it in tmux, add to your ~/.tmux.conf:"
echo -e "  set -g default-command $(which zsh)\n"

