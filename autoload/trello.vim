" =================================
" variables
" =================================
let s:boards_buffer = 'BOARDS'
let s:lists_buffer = 'LISTS'
let s:cards_buffer = 'CARDS'
let s:single_card_buffer = 'CARD'


" =================================
" 【Main】vim-trello
" =================================
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


" =================================
" show Boards in new buffer
"  - Boards Buffer Setting
" =================================
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


" =================================
" show Lists in new buffer
"  - Lists Buffer Setting
" =================================
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
  call s:OpenCardsNewBuffer(l:listDict, l:listId)

endfunction


" =================================
" show Cards in new buffer
"  - Cards Buffer Setting
" =================================
function! s:OpenCardsNewBuffer(listDict, listId)

  echomsg "=================================="
  echomsg "listId: " . a:listId
  echomsg ""
  echomsg "=================================="

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
"  TODO pass ID to AddNewCard function
  nnoremap <buffer> a :call AddNewCard("test")<CR>

  call s:WriteDictToBuf(a:listDict)

endfunction

function! AddNewCard(title)
  echomsg s:AddNewCardCmd("idList", a:title)
  echomsg a:title
  echomsg "==== add new card ===="
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

  let l:desc = s:GetDescFromRes(l:result)
  call s:OpenSingleCardNewBuffer(l:desc)

endfunction


" =================================
" show description of single card in new buffer
"  - Description of single card Buffer Setting
" =================================
function! s:OpenSingleCardNewBuffer(desc)

  if a:desc == ""
    return
  endif

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
" 【Common】functions
" =================================
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

function! s:GetDescFromRes(response)
  let l:desc = 'desc'
  if has_key(a:response, l:desc)
    return a:response[l:desc]
  endif
  return ''
endfunction

function! s:WriteDictToBuf(dict)
  echomsg keys(a:dict)
  for key in keys(a:dict)
    let l:row = a:dict[key] . "(" . key . ")"
    call append(line(0), l:row)
    echomsg l:row
  endfor
endfunction

function! s:AddPostParams(url, idList, name)
  let l:absolute_url = a:url
  if a:idList == ""
    throw  "param 'idList' is required to add new Card"
  endif
  if a:name != ""
    let l:absolute_url = l:absolute_url .  "&name=" . a:name
  endif
  let l:absolute_url = l:absolute_url . "&idList=" . a:idList
  return l:absolute_url
endfunction


" =================================
" curl commands
" =================================
function! s:GetBoardsCmd()
  let l:path = "/1/members/me/boards"
  return  s:CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:GetListsCmd(boardId)
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

function! s:AddNewCardCmd(listId, title)
  let l:path = "/1/cards"
  let l:absolute_url = s:AddPostParams(s:BuildTrelloApiUrl(l:path), a:listId, a:title)
  return  s:CurlPostCmd(l:absolute_url)
endfunction

function! s:CurlGetCmd(url)
  return "curl -s --request GET --url '" . a:url . "'"
endfunction

function! s:CurlPostCmd(url)
  return "curl -s --request POST --url '" . a:url . "'"
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
  execute 50 'vnew' a:bufName
endfunction


" =================================
" for debug
"  - debug this script by `:so %`
" =================================
call g:trello#VimTrello()
