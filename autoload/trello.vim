" =================================
" variables
" =================================
let s:boards_buffer = 'BOARDS'
let s:lists_buffer = 'LISTS'
let s:cards_buffer = 'CARDS'
let s:single_card_buffer = 'CARD'


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

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:boardDict = s:GetIdAndNameDictFromResList(l:result)
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

  call s:WriteDictToBuf(a:boardDict)

endfunction


" get Boards from Lists
function! GetLists(boardName)

  echomsg a:boardName
  if a:boardName == ""
    return
  endif

  let l:boardId = s:GetIdFromLine(a:boardName)
  echomsg l:boardId
  let l:cmd = s:GetListsCmd(l:boardId)
  echomsg l:cmd

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:listDict = s:GetIdAndNameDictFromResList(l:result)
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

  call s:WriteDictToBuf(a:listDict)

endfunction


" get Cards from Lists
function! GetCards(listName)

  echomsg a:listName
  if a:listName == ""
    return
  endif

  let l:listId = s:GetIdFromLine(a:listName)
  echomsg l:listId
  let l:cmd = s:GetCardsCmd(l:listId)
  echomsg l:cmd

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:listDict = s:GetIdAndNameDictFromResList(l:result)
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
    \ :<C-u>call GetSingleCard(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-list)
  nmap <buffer> <CR> <Plug>(lists-open)

  call s:WriteDictToBuf(a:listDict)

endfunction


" get single card
function! GetSingleCard(cardName)

  echomsg a:cardName
  if a:cardName == ""
    return
  endif

  let l:cardId = s:GetIdFromLine(a:cardName)
  let l:cmd = s:GetSingleCardCmd(l:cardId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:desc= l:result['desc']
  call s:OpenSingleCardNewBuffer(l:desc)

endfunction


" show description of single card in new buffer
function! s:OpenSingleCardNewBuffer(desc)

  call s:CloseBuf()
  call s:OpenNewBuf(s:single_card_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-buf)
    \ :<C-u>bwipeout!<CR>
  nmap <buffer> q <Plug>(close-buf)

  call setline(1, a:desc)

endfunction


" =================================
" common functions
" =================================
function! s:GetIdFromLine(line)
  return a:line[stridx(a:line,'(') + 1 : stridx(a:line,')') - 1]
endfunction

function! s:GetIdAndNameDictFromResList(responseList)
  let l:dict = {}
  for response in a:responseList
    let l:dict[response['id']] = response['name']
  endfor
  echomsg l:dict
  return l:dict
endfunction

function! s:WriteDictToBuf(dict)
  echomsg keys(a:dict)
  for key in keys(a:dict)
    let l:row = a:dict[key] . "(" . key . ")"
    call append(line(0), l:row)
    echomsg l:row
  endfor
endfunction


" =================================
" curl commands
" =================================
function! s:GetBoardsCmd()
  let l:path = "/1/members/me/boards"
  return  s:CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

functio! s:GetListsCmd(boardId)
  let l:path = "/1/boards/" . a:boardId . "/lists"
  return  s:CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:GetCardsCmd(listId)
  let l:path = "/1/lists/" . a:listId . "/cards"
  return  s:CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:GetSingleCardCmd(cardId)
  let l:path = "/1/cards/" . a:cardId
  return  s:CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:CurlGetCmd(url)
  return "curl -s --request GET --url '" . a:url . "'"
endfunction

function! s:BuildTrelloApiUrl(path)
  return "https://api.trello.com" . a:path . "?key=" . g:vimTrelloApiKey . "&token=" . g:vimTrelloToken
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
