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

  let l:cmd = g:command#GetBoardsCmd()

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:boardDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenBoardsNewBuffer(l:boardDict)

endfunction


function! GetBoards()
  let l:cmd = g:command#GetBoardsCmd()
  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let l:boardDict = g:common#GetIdAndNameDictFromResList(l:result)
  call g:common#CloseBuf()
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
  nnoremap <silent> <buffer> <Plug>(close-boards) :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer> <Plug>(open-boards) :<C-u>call GetLists(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-boards)
  nmap <buffer> <CR> <Plug>(open-boards)

  let l:desc_a_key = '(a)dd new Board'
  let l:desc_d_key = '(d)elete a Board'
  let l:desc_q_key = '(q) close buffer'
  let l:desc_enter_key = '(Enter) show Board'

  call g:common#WriteDictToBuf(a:boardDict)
  call g:common#WriteTitleToBuf('[BOARDS]')
  call append(0, '')
  call append(0, '============================')
  call append(0, l:desc_enter_key)
  call append(0, l:desc_q_key)
  call append(0, '========= key map ==========')

endfunction


" get Boards from Lists
function! GetLists(boardName)

  if a:boardName == ""
    return
  endif

  let l:boardId = g:common#GetIdFromLine(a:boardName)
  call GetListsByBoardId(l:boardId)

endfunction

function! GetListsByBoardId(boardId)
  let l:cmd = g:command#GetListsCmd(a:boardId)
  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenListsNewBuffer(l:listDict, a:boardId)
endfunction


" =================================
" show Lists in new buffer
"  - Lists Buffer Setting
" =================================
function! s:OpenListsNewBuffer(listDict, boardId)

  let l:lists_buffer = 'LISTS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:lists_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer> <Plug>(get-boards) :<C-u>call GetBoards()<CR>
  nnoremap <silent> <buffer> <Plug>(close-lists) :<C-u>bwipeout!<CR>
  exec 'nnoremap <silent> <buffer> <Plug>(open-lists) :<C-u>call GetCards(trim(getline(".")), "' . a:boardId . '")<CR>'
  nmap <buffer> b <Plug>(get-boards)
  nmap <buffer> q <Plug>(close-lists)
  nmap <buffer> <CR> <Plug>(open-lists)

  let l:desc_a_key = '(a)dd new List'
  let l:desc_b_key = '(b)ack to boards'
  let l:desc_d_key = '(d)elete a List'
  let l:desc_q_key = '(q) close buffer'
  let l:desc_enter_key = '(Enter) show Tasks'

  call g:common#WriteDictToBuf(a:listDict)
  call g:common#WriteTitleToBuf('[LISTS of the Board]')
  call append(0, '')
  call append(0, '============================')
  call append(0, l:desc_enter_key)
  call append(0, l:desc_q_key)
  call append(0, l:desc_b_key)
  call append(0, '========= key map ==========')

endfunction


" get Cards from Lists
function! GetCards(listName, boardId)

  if a:listName == ""
    return
  endif

  let l:listId = g:common#GetIdFromLine(a:listName)
  call GetCardsById(l:listId, a:boardId)
  let l:cmd = g:command#GetCardsCmd(l:listId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, l:listId, a:boardId)

endfunction


function! GetCardsById(listId, boardId)
  let l:cmd = g:command#GetCardsCmd(a:listId)
  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, a:listId, a:boardId)
endfunction


" =================================
" show Cards in new buffer
"  - Cards Buffer Setting
" =================================
function! s:OpenCardsNewBuffer(listDict, listId, boardId)

  let l:cards_buffer = 'CARDS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:cards_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(add-card) :<C-u>call OpenAddNewTaskArea("' . a:listId . '", "' . a:boardId . '")<CR>'
  exec 'nnoremap <silent> <buffer> <Plug>(get-lists) :<C-u>call GetListsByBoardId("' . a:boardId . '")<CR>'
  exec 'nnoremap <silent> <buffer> <Plug>(delete-card) :<C-u>call DeleteCard(trim(getline(".")), "' . a:listId . '", "' . a:boardId . '")<CR>'
  exec 'nnoremap <silent> <buffer> <Plug>(open-cards) :<C-u>call GetSingleCard(trim(getline(".")), "' . a:listId . '", "' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(close-cards) :<C-u>bwipeout!<CR>
  nmap <buffer> a <Plug>(add-card)
  nmap <buffer> b <Plug>(get-lists)
  nmap <buffer> d <Plug>(delete-card)
  nmap <buffer> q <Plug>(close-cards)
  nmap <buffer> <CR> <Plug>(open-cards)

  let l:desc_a_key = '(a)dd new Task'
  let l:desc_b_key = '(b)ack to Lists'
  let l:desc_d_key = '(d)elete a Task'
  let l:desc_q_key = '(q) close buffer'
  let l:desc_enter_key = '(Enter) show detail of Task'

  call g:common#WriteDictToBuf(a:listDict)
  call g:common#WriteTitleToBuf('[TASKS]')
  call append(0, '')
  call append(0, '============================')
  call append(0, l:desc_enter_key)
  call append(0, l:desc_q_key)
  call append(0, l:desc_d_key)
  call append(0, l:desc_b_key)
  call append(0, l:desc_a_key)
  call append(0, '========= key map ==========')

endfunction


function! OpenAddNewTaskArea(listId, boardId)
  " accept user input
  call inputsave()
  let l:userInput=input("Enter title of card which you want to add.\nTask name: ")
  call inputrestore()

  call AddNewCard(a:listId, l:userInput)

  " get latest cards
  let l:cmd = g:command#GetCardsCmd(a:listId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  " show latest cards
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, a:listId, a:boardId)
endfunction


" add single card
function! AddNewCard(listId, title)
  let l:cmd = g:command#AddNewCardCmd(a:listId, a:title)
  call system(l:cmd)
endfunction


" delete card
function! DeleteCard(cardName, listId, boardId)

  if a:cardName == ""
    return
  endif

  let l:cardId = g:common#GetIdFromLine(a:cardName)
  let l:cmd = g:command#DeleteCardCmd(l:cardId)

  call system(l:cmd)

  " get latest cards
  let l:cmd = g:command#GetCardsCmd(a:listId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  " show latest cards
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call s:OpenCardsNewBuffer(l:listDict, a:listId, a:boardId)

endfunction

" get single card
function! GetSingleCard(cardName, listId, boardId)

  if a:cardName == ""
    return
  endif

  let l:cardId = g:common#GetIdFromLine(a:cardName)
  let l:cmd = g:command#GetSingleCardCmd(l:cardId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:desc = g:common#GetDescFromRes(l:result)
  call g:task_detail#OpenSingleCardNewBuffer(l:desc, a:listId, a:boardId)

endfunction


" =================================
" for debug
"  - debug this script by `:so %`
" =================================
call g:trello#VimTrello()
