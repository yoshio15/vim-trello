" =================================
" Tasks
" =================================
function! g:task#OpenCardsNewBuffer(listDict, listId, boardId)

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

  call AddNewCard(a:listId, UrlEncode(l:userInput))

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
  call g:task#OpenCardsNewBuffer(l:listDict, a:listId, a:boardId)
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
  call g:task#OpenCardsNewBuffer(l:listDict, a:listId, a:boardId)

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
