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

  let l:boards_buffer = 'BOARDS'
  call g:common#OpenNewBuf(l:boards_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-boards)
    \ :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(open-boards)
    \ :<C-u>call GetLists(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-boards)
  nmap <buffer> <CR> <Plug>(open-boards)

  call g:common#WriteDictToBuf(a:boardDict)
  call g:common#WriteTitleToBuf('[YOUR BOARDS]')

endfunction


" get Boards from Lists
function! GetLists(boardName)

  if a:boardName == ""
    return
  endif

  let l:boardId = g:common#GetIdFromLine(a:boardName)
  let l:cmd = s:GetListsCmd(l:boardId)

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

  let l:lists_buffer = 'LISTS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:lists_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-lists)
    \ :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(open-lists)
    \ :<C-u>call GetCards(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-lists)
  nmap <buffer> <CR> <Plug>(open-lists)

  call g:common#WriteDictToBuf(a:listDict)
  call g:common#WriteTitleToBuf('[LISTS of the Board]')

endfunction


" get Cards from Lists
function! GetCards(listName)

  if a:listName == ""
    return
  endif

  let l:listId = g:common#GetIdFromLine(a:listName)
  let l:cmd = s:GetCardsCmd(l:listId)

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

  let l:cards_buffer = 'CARDS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:cards_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(add-card) :<C-u>call OpenAddNewTaskArea("' . a:listId . '")<CR>'
  exec 'nnoremap <silent> <buffer> <Plug>(delete-card) :<C-u>call DeleteCard(trim(getline(".")), "' . a:listId . '")<CR>'
  nnoremap <silent> <buffer>
    \ <Plug>(close-cards)
    \ :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer>
    \ <Plug>(open-cards)
    \ :<C-u>call GetSingleCard(trim(getline('.')))<CR>
  nmap <buffer> a <Plug>(add-card)
  nmap <buffer> d <Plug>(delete-card)
  nmap <buffer> q <Plug>(close-cards)
  nmap <buffer> <CR> <Plug>(open-cards)

  call g:common#WriteDictToBuf(a:listDict)
  call g:common#WriteTitleToBuf('[TASKS]')

endfunction


function! OpenAddNewTaskArea(listId)
  " accept user input
  call inputsave()
  let l:userInput=input("Enter title of card which you want to add.\nTask name: ")
  call inputrestore()

  call AddNewCard(a:listId, l:userInput)

  " get latest cards
  let l:cmd = s:GetCardsCmd(a:listId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  " show latest cards
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, a:listId)
endfunction


" add single card
function! AddNewCard(listId, title)
  let l:cmd = s:AddNewCardCmd(a:listId, a:title)
  call system(l:cmd)
endfunction


" delete card
function! DeleteCard(cardName, listId)

  if a:cardName == ""
    return
  endif

  let l:cardId = g:common#GetIdFromLine(a:cardName)
  let l:cmd = s:DeleteCardCmd(l:cardId)

  call system(l:cmd)

  " get latest cards
  let l:cmd = s:GetCardsCmd(a:listId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  " show latest cards
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, a:listId)

endfunction

" get single card
function! GetSingleCard(cardName)

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

  let l:single_card_buffer = 'CARD'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:single_card_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-buf)
    \ :<C-u>bwipeout!<CR>
  nmap <buffer> q <Plug>(close-buf)

  call setline(1, a:desc)
  call g:common#WriteTitleToBuf('[Detail of a TASK]')

endfunction


" =================================
" curl commands
" =================================
function! s:GetBoardsCmd()
  let l:path = "/1/members/me/boards"
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:GetListsCmd(boardId)
  let l:path = "/1/boards/" . a:boardId . "/lists"
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:GetCardsCmd(listId)
  let l:path = "/1/lists/" . a:listId . "/cards"
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:GetSingleCardCmd(cardId)
  let l:path = "/1/cards/" . a:cardId
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:AddNewCardCmd(listId, title)
  let l:path = "/1/cards"
  let l:absolute_url = g:common#AddPostParams(s:BuildTrelloApiUrl(l:path), a:listId, a:title)
  return  g:curl#CurlPostCmd(l:absolute_url)
endfunction

function! s:DeleteCardCmd(cardId)
  let l:path = "/1/cards/" . a:cardId
  return  g:curl#CurlDeleteCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:BuildTrelloApiUrl(path)
  return "https://api.trello.com" . a:path . "?key=" . g:vimTrelloApiKey . "&token=" . g:vimTrelloToken
endfunction


" =================================
" for debug
"  - debug this script by `:so %`
" =================================
call g:trello#VimTrello()
