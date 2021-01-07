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
    call g:common#CheckEnv()
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

  let l:boardDict = g:common#GetIdAndNameDictFromResList(l:result)
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

  call g:common#WriteDictToBuf(a:boardDict)

endfunction


" get Boards from Lists
function! GetLists(boardName)

  echomsg a:boardName
  if a:boardName == ""
    return
  endif

  let l:boardId = g:common#GetIdFromLine(a:boardName)
  echomsg l:boardId
  let l:cmd = s:GetListsCmd(l:boardId)
  echomsg l:cmd

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
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

  call g:common#WriteDictToBuf(a:listDict)

endfunction


" get Cards from Lists
function! GetCards(listName)

  echomsg a:listName
  if a:listName == ""
    return
  endif

  let l:listId = g:common#GetIdFromLine(a:listName)
  echomsg l:listId
  let l:cmd = s:GetCardsCmd(l:listId)
  echomsg l:cmd

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, l:listId)

endfunction


" =================================
" show Cards in new buffer
"  - Cards Buffer Setting
" =================================
function! s:OpenCardsNewBuffer(listDict, listId)

  call s:CloseBuf()
  call s:OpenNewBuf(s:cards_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(add-card) :<C-u>call OpenAddNewTaskArea("' . a:listId . '")<CR>'
  nnoremap <silent> <buffer>
    \ <Plug>(delete-card)
    \ :<C-u>call DeleteCard(trim(getline('.')))<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(close-list)
    \ :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(lists-open)
    \ :<C-u>call GetSingleCard(trim(getline('.')))<CR>
  nmap <buffer> a <Plug>(add-card)
  nmap <buffer> d <Plug>(delete-card)
  nmap <buffer> q <Plug>(close-list)
  nmap <buffer> <CR> <Plug>(lists-open)

  call g:common#WriteDictToBuf(a:listDict)

endfunction


function! OpenAddNewTaskArea(listId)
  " accept user input
  call inputsave()
  let l:userInput=input("Enter title of card which you want to add.\nTask name: ")
  call inputrestore()

  call AddNewCard(a:listId, l:userInput)
endfunction


" add single card
function! AddNewCard(listId, title)
  echomsg "==== add new card ===="
  echomsg "title: " . a:title
  echomsg "listid: " . a:listId
  echomsg "======================"
  let l:cmd = s:AddNewCardCmd(a:listId, a:title)
  echomsg "cmd: " . l:cmd
  echomsg system(l:cmd)
endfunction


" delete card
function! DeleteCard(cardName)

  echomsg a:cardName
  if a:cardName == ""
    return
  endif

  let l:cardId = g:common#GetIdFromLine(a:cardName)
  let l:cmd = s:DeleteCardCmd(l:cardId)

  echomsg "cmd: " . l:cmd
  echomsg system(l:cmd)

endfunction

" get single card
function! GetSingleCard(cardName)

  echomsg a:cardName
  if a:cardName == ""
    return
  endif

  let l:cardId = g:common#GetIdFromLine(a:cardName)
  let l:cmd = s:GetSingleCardCmd(l:cardId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:desc = g:common#GetDescFromRes(l:result)
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
  let l:absolute_url = g:common#AddPostParams(s:BuildTrelloApiUrl(l:path), a:listId, a:title)
  return  s:CurlPostCmd(l:absolute_url)
endfunction

function! s:DeleteCardCmd(cardId)
  let l:path = "/1/cards/" . a:cardId
  return  s:CurlDeleteCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:CurlGetCmd(url)
  return "curl -s --request GET --url '" . a:url . "'"
endfunction

function! s:CurlPostCmd(url)
  return "curl -s --request POST --url '" . a:url . "'"
endfunction

function! s:CurlDeleteCmd(url)
  return "curl -s --request DELETE --url '" . a:url . "'"
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
