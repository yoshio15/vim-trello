# vim-trello
Vim plugin for [Trello](https://trello.com/)

![vim-trello2](https://user-images.githubusercontent.com/51875964/104024220-204b0180-5206-11eb-8a3d-e05e1ac473f3.gif)

## Installation
### vim-plug
```vim
Plug 'yoshio15/vim-trello', { 'branch': 'main' }
```
and execute `:PlugInstall` command to install vim-trello.

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
### ■ Boards
| key | action |
| --- | ------ |
| q | close buffer |
| Enter | show the Board |

### ■ Lists
| key | action |
| --- | ------ |
| a | add new List |
| b | back to Boards |
| q | close buffer |
| Enter | show the List |

### ■ Tasks
| key | action |
| --- | ------ |
| a | add new Task |
| b | back to Lists |
| d | delete the Task |
| e | edit the title of Task |
| q | close buffer |
| Enter | show the Task |

### ■ Task Detail
| key | action |
| --- | ------ |
| b | back to Tasks |
| q | close buffer |

## Author
Yoshio Kondo

## License
This software is released under the MIT License, see LICENSE.
