#!/bin/bash

PS3='Setup: '
option=(
'Symbolic link of .virmrc, .tmux.conf and colors'
'Symbolic link of .zshrc'
'Oh My ZSH!'
'Tmux Plugin Manager'
'Homebrew'
'Vundle'
'Powerline fonts'
'BetterSnapTool info'
'Quit'
)
select opt in "${option[@]}"
do
    case $opt in
        'Symbolic link of .virmrc, .tmux.conf and colors')
            ln -sf ~/.dotfiles/.vimrc ~/.vimrc
            ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
            mkdir ~/.vim 
            rm -rf ~/.vim/colors
            ln -sf ~/.dotfiles/colors ~/.vim/colors
            echo 'Done!'
            ;;
        'Symbolic link of .zshrc')
            ln -sf ~/.dotfiles/.zshrc ~/.zshrc
            echo 'Done!'
            ;;
        'Oh My ZSH!')
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
            ;;
        'Tmux Plugin Manager')
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
            echo 'tmux, CTRL + B, I'
            ;;
        'Homebrew')
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            ;;
        'Vundle')
            git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
            vim +PluginInstall +qall
            ;;
        'Powerline fonts')
            git clone https://github.com/powerline/fonts.git ~/.powerline
            ~/.powerline/install.sh
            rm -rf ~/.powerline
            echo 'Done!'
            ;;
        'BetterSnapTool info')
            echo 'Maximize: Command + Up'
            echo 'Left half: Command + Left'
            echo 'Right half: Command + Right'
            ;;
        'Quit')
            break
            ;;
        *)
            echo 'Invalid option'
            ;;
    esac
done
