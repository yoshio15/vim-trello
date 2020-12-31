" =================================
" variables
" =================================
let s:boards_buffer = 'BOARDS'
let s:lists_buffer = 'LISTS'
let s:cards_buffer = 'CARDS'


" vim-trello(main)
function! g:trello#VimTrello()

  try
    call s:CheckEnv()
  catch
    echomsg v:exception
    return
  endtry

  let l:cmd = GetBoardsCmd()
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:boardDict = {}
  for board in l:result
    :let l:boardDict[board['id']] = board['name']
  endfor
  echomsg l:boardDict
  call OpenBoardsNewBuffer(l:boardDict)
endfunction


" check enviroment
function! s:CheckEnv()
  if !executable('curl')
    throw "curl is not available"
  endif
  if !exists('g:vimTrelloApiKey')
    throw "g:apiKey is not difined in your vimrc"
  endif
  if !exists('g:vimTrelloToken')
    throw "g:token is not difined in your vimrc"
  endif
endfunction


" show Boards in new buffer
function! OpenBoardsNewBuffer(boardDict)
  call OpenNewBuf(s:boards_buffer)
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


" get Boards from Lists
function! GetLists(boardName)

  echomsg a:boardName
  if a:boardName == ""
    return
  endif

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


" show Lists in new buffer
function! OpenListsNewBuffer(listDict)
  call CloseBuf()
  call OpenNewBuf(s:lists_buffer)
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


" get Cards from Lists
function! GetCards(listName)

  echomsg a:listName
  if a:listName == ""
    return
  endif

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
  call OpenCardsNewBuffer(l:listDict)
endfunction


" show Cards in new buffer
function! OpenCardsNewBuffer(listDict)
  call CloseBuf()
  call OpenNewBuf(s:cards_buffer)
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


" =================================
" curl commands
" =================================
function! GetBoardsCmd()
  return "curl -s -X GET 'https://api.trello.com/1/members/me/boards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
endfunction

function! GetListsCmd(boardId)
  return "curl -s --request GET --url 'https://api.trello.com/1/boards/" . a:boardId . "/lists?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
endfunction

function! GetCardsCmd(listId)
  return "curl -s --request GET --url 'https://api.trello.com/1/lists/" . a:listId . "/cards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
endfunction


" =================================
" manipulate buffer
" =================================
function! CloseBuf()
  execute 'bwipeout'
endfunction

function! OpenNewBuf(bufName)
  execute 'vnew' a:bufName
endfunction

call g:trello#VimTrello()
