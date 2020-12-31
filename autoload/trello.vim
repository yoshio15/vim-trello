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

  let l:cmd = s:GetBoardsCmd()
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:boardDict = {}
  for board in l:result
    :let l:boardDict[board['id']] = board['name']
  endfor
  echomsg l:boardDict
  call s:OpenBoardsNewBuffer(l:boardDict)
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
function! s:OpenBoardsNewBuffer(boardDict)
  call s:OpenNewBuf(s:boards_buffer)
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
  let l:cmd = s:GetListsCmd(l:boardId)
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:listDict = {}
  for elem in l:result
    :let l:listDict[elem['id']] = elem['name']
  endfor
  echomsg l:listDict
  call s:OpenListsNewBuffer(l:listDict)
endfunction


" show Lists in new buffer
function! s:OpenListsNewBuffer(listDict)
  call s:CloseBuf()
  call s:OpenNewBuf(s:lists_buffer)
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
  let l:cmd = s:GetCardsCmd(l:listId)
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:listDict = {}
  for elem in l:result
    :let l:listDict[elem['id']] = elem['name']
  endfor
  echomsg l:listDict
  call s:OpenCardsNewBuffer(l:listDict)
endfunction


" show Cards in new buffer
function! s:OpenCardsNewBuffer(listDict)
  call s:CloseBuf()
  call s:OpenNewBuf(s:cards_buffer)
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
function! s:GetBoardsCmd()
  return "curl -s -X GET 'https://api.trello.com/1/members/me/boards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
endfunction

functio! s:GetListsCmd(boardId)
  return "curl -s --request GET --url 'https://api.trello.com/1/boards/" . a:boardId . "/lists?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
endfunction

function! s:GetCardsCmd(listId)
  return "curl -s --request GET --url 'https://api.trello.com/1/lists/" . a:listId . "/cards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
endfunction


" =================================
" manipulate buffer
" =================================
function! s:CloseBuf()
  execute 'bwipeout'
endfunction

function! s:OpenNewBuf(bufName)
  execute 'vnew' a:bufName
endfunction

call g:trello#VimTrello()
