" main
function! g:trello#VimTrello()
  if !executable('curl')
    echo 'curl is not available'
    return
  endif
  if !exists('g:vimTrelloApiKey')
    echo 'g:apiKey is not difined in your vimrc'
    return
  endif
  if !exists('g:vimTrelloToken')
    echo 'g:token is not difined in your vimrc'
    return
  endif
  let l:cmd = GetBoardsCmd()
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:boardDict = {}
  for board in l:result
    :let l:boardDict[board['id']] = board['name']
  endfor
  echomsg l:boardDict
  call OpenNewBuffer(l:boardDict)
endfunction

" Board一覧を取得するコマンド
function! GetBoardsCmd()
  let l:cmd = "curl -s -X GET 'https://api.trello.com/1/members/me/boards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
  return l:cmd
endfunction

" Boardリストを表示するバッファを生成する
let s:board_list_buffer = 'BOARDS'
function! OpenNewBuffer(boardDict)
  call OpenNewBuf(s:board_list_buffer)
  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-list)
    \ :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(lists-open)
    \ :<C-u>call GetLists(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-list)
  nmap <buffer> <CR> <Plug>(lists-open)
  echomsg keys(a:boardDict)
  for key in keys(a:boardDict)
    let l:row = a:boardDict[key] . "(" . key . ")"
    call append(line(0), l:row)
    echomsg l:row
  endfor
endfunction

" Board内のリスト一覧を取得する
function! GetLists(boardName)
  echomsg a:boardName
  let l:boardId = a:boardName[stridx(a:boardName,'(')+1:stridx(a:boardName,')')-1]
  echomsg l:boardId
  let l:cmd = GetListsCmd(l:boardId)
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:listDict = {}
  for elem in l:result
    :let l:listDict[elem['id']] = elem['name']
  endfor
  echomsg l:listDict
  call OpenListsNewBuffer(l:listDict)
endfunction

" Board内のリスト一覧を取得するコマンド
function! GetListsCmd(boardId)
  let l:cmd = "curl -s --request GET --url 'https://api.trello.com/1/boards/" . a:boardId . "/lists?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
  return l:cmd
endfunction

" リスト一覧を表示するバッファを生成する
let s:card_list_buffer = 'LISTS'
function! OpenListsNewBuffer(listDict)
  call CloseBuf()
  call OpenNewBuf(s:card_list_buffer)
  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-list)
    \ :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(lists-open)
    \ :<C-u>call GetCards(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-list)
  nmap <buffer> <CR> <Plug>(lists-open)
  echomsg keys(a:listDict)
  for key in keys(a:listDict)
    let l:row = a:listDict[key] . "(" . key . ")"
    call append(line(0), l:row)
    echomsg l:row
  endfor
endfunction

" リスト内のカード一覧を取得するコマンド
function! GetCardsCmd(listId)
  let l:cmd = "curl -s --request GET --url 'https://api.trello.com/1/lists/" . a:listId . "/cards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
  return l:cmd
endfunction

" リスト内のカード一覧を取得する
function! GetCards(listName)
  echomsg a:listName
  let l:listId = a:listName[stridx(a:listName,'(')+1:stridx(a:listName,')')-1]
  echomsg l:listId
  let l:cmd = GetCardsCmd(l:listId)
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:listDict = {}
  for elem in l:result
    :let l:listDict[elem['id']] = elem['name']
  endfor
  echomsg l:listDict
  call OpenListsNewBuffer(l:listDict)
endfunction

" バッファを閉じる
function! CloseBuf()
  execute 'bwipeout'
endfunction

" バッファを開く
function! OpenNewBuf(bufName)
  execute 'vnew' a:bufName
endfunction

call g:trello#VimTrello()
