# Reaver

[![Gem
Version](https://badge.fury.io/rb/reaver.svg)](https://badge.fury.io/rb/reaver)

A tool that allows to download and track the latest version of stuff on the net.
Define your collections in .yml and launch Reaver to retrieve everything and
move things to the right spot.

## Dependencies

Reaver need only `unzip`, `xz`, `tar` and `git`, depending what you'll use.

## Collections

Reaver search collections by order in:

- `$XDG_CONFIG_HOME/reaver`
- `$HOME/.config/reaver`

## Create many collection of things

For example, your need to use Vim, vim require a lots of external plugins to be more efficient, so create a collection called `vim.yml`.

    $ $EDITOR ~/.config/reaver/vim.yml

In the file, we add all archives required by your projects.

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
all_into_dir: .config/pack/myvimpluggins/start
keep_name: true
```

To see more examples, look my [dotfiles repository](https://github.com/szorfein/dotfiles), each directory contain a list of tasks for Reaver.

## Launch

After declaring your need, start Reaver simply with:

    $ reaver

Reaver download all files in `~/.cache/reaver` by default.

### Few rules

A collection can include:

- `all_into_dir: <dirname>` if all files go in a directory. Directory is created
  if not exist.
- `keep_name: <boolean>`, if `true`, create a directory with the name of the thing, e.g, for a name `ombre.tar.gz`, the final destination will be `all_into_dir/ombre` or `dest_dir/ombre`.
- `force_download: <boolean>`, if you make change and want to download now, change to `true`.
- `things[].dest_dir: <dirname>`, if each files go in different directory, use this.
- `things[].name` the new name after download, may include the file extension.
- `things[].strip_components: <number>`, used on `tar`, default to 1, skip the first
  directory from an archive, if no subdirectory exist, you should set to 0.
- `things[].url: <string>`
- `things[].git: <boolean>`, If the thing need to be managed with git.
- `time: 86000` (in second) is for search every day ( 60 _ 60 _ 24 ).

If `all_into_dir` is defined, `things[].dest_dir` is not used.  
All paths given are relative to `$HOME` so don't include `~` or any shell
variables.
