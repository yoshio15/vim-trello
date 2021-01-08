# vim-trello
Vim plugin for [Trello](https://trello.com/)

![vim-trello](https://user-images.githubusercontent.com/51875964/104023434-052bc200-5205-11eb-823d-de5640850cc7.gif)

## Installation
### vim-plug
```vim
Plug 'yoshio15/vim-trello', { 'branch': 'main' }
```

## Setting
set your [api key and token of Trello](https://trello.com/app-key) in your vimrc.
```vim
" Trello API Key
let g:vimTrelloApiKey = '{your api key}'
let g:vimTrelloToken = '{your token}'
```

## Usage
```vim
:VimTrello
```
you can open your boards list of trello assosiaded with your Trello account by this command.  

## Key Map
| key | action |
| --- | ------ |
| a | add new card |
| q | close buffer |
| d | delete a card |

## Author
Yoshio Kondo

## License
This software is released under the MIT License, see LICENSE.
