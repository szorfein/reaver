# harpoon

A tools to downloads things on the net. Harpoon is used to get all files
required by your project, track the last version, etc.

## Collections

Harpoon search collections by order in:

- `$XDG_CONFIG_HOME/harpoon`
- `$HOME/.config/harpoon`

## Create a collection of things

For example, your need to use Vim, vim require a lots of external plugins to be more efficient, so create a collection called `vim.yml`.

    $ $EDITOR ~/.config/harpoon/vim.yml

In the file, we add all archives required by u projects

```yml
---
things:
  - name: ombre.tar.gz
    url: https://github.com/szorfein/ombre.vim/archive/refs/heads/main.tar.gz
  - name: ale.tar.gz
    url: https://github.com/dense-analysis/ale/archive/refs/heads/master.tar.gz
  - name: indentline.tar.gz
    url: https://github.com/Yggdroot/indentLine/archive/refs/heads/master.tar.gz
  - name: nerdtree.tar.gz
    url: https://github.com/preservim/nerdtree/archive/refs/heads/master.tar.gz
time: 86000
```

`time: 86000` (in second) is for search every day ( 60 * 60 * 24 ).  
And start harpoon simply

    $ harpoon