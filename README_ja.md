# vim-trello
[Trello](https://trello.com/)をVim上で利用できるプラグイン。

![vim-trello2](https://user-images.githubusercontent.com/51875964/104024220-204b0180-5206-11eb-8a3d-e05e1ac473f3.gif)

## インストール
### vim-plug
```vim
Plug 'yoshio15/vim-trello', { 'branch': 'main' }
```
`:PlugInstall` を実行する。

## 設定方法
以下の通り、.vimrcに[TrelloのAPIキーとトークン](https://trello.com/app-key)を設置する。
```vim
" Trello API Key
let g:vimTrelloApiKey = '{your api key}'
let g:vimTrelloToken = '{your token}'
```

## 使い方
```vim
:VimTrello
```
Trelloアカウントに紐づいたボード一覧が表示される。

## キーマッピング 
### ■ ボード
| キー | アクション |
| ---- | ------ |
| q | 表示しているバッファを閉じる |
| Enter | 選択したボードを表示する |

### ■ リスト
| キー | アクション |
| ---- | ------ |
| a | リストを追加する |
| b | ボード一覧に戻る |
| d | リストを削除（アーカイブ）する |
| q | 表示しているバッファを閉じる |
| Enter | 選択したリストを表示する |

### ■ タスク
| キー | アクション |
| ---- | ------ |
| a | タスクを追加する |
| b | リスト一覧に戻る |
| d | タスクを削除（アーカイブ）する |
| e | タスクのタイトルを編集する |
| q | 表示しているバッファを閉じる |
| Enter | 選択したタスクを表示する |

### ■ タスク詳細
| キー | アクション |
| ---- | ------ |
| b | タスク一覧に戻る|
| q | 表示しているバッファを閉じる |

## 作者
Yoshio Kondo

## ライセンス
MIT Lisence
