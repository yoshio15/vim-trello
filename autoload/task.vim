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
  exec 'nnoremap <silent> <buffer> <Plug>(edit-card) :<C-u>call EditCardTitle(trim(getline(".")), "' . a:listId . '", "' . a:boardId . '")<CR>'
  exec 'nnoremap <silent> <buffer> <Plug>(open-cards) :<C-u>call GetSingleCard(trim(getline(".")), "' . a:listId . '", "' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(close-cards) :<C-u>bwipeout!<CR>
  nmap <buffer> a <Plug>(add-card)
  nmap <buffer> b <Plug>(get-lists)
  nmap <buffer> d <Plug>(delete-card)
  nmap <buffer> e <Plug>(edit-card)
  nmap <buffer> q <Plug>(close-cards)
  nmap <buffer> <CR> <Plug>(open-cards)

  let l:desc_a_key = '(a)dd new Task'
  let l:desc_b_key = '(b)ack to Lists'
  let l:desc_d_key = '(d)elete a Task'
  let l:desc_e_key = '(e)dit the title of Task'
  let l:desc_q_key = '(q) close buffer'
  let l:desc_enter_key = '(Enter) show detail of Task'

  call append(0, l:desc_enter_key)
  call append(0, l:desc_q_key)
  call append(0, l:desc_e_key)
  call append(0, l:desc_d_key)
  call append(0, l:desc_b_key)
  call append(0, l:desc_a_key)
  call append(line("$"), '')
  call append(line("$"), '" Tasks')
  call g:common#WriteDictListToBuf(g:taskDictList)
  setlocal nomodifiable

endfunction


function! OpenAddNewTaskArea(listId, boardId)
  " accept user input
  call inputsave()
  let l:userInput=input("Enter title of card which you want to add.\nTask name: ")
  call inputrestore()

  call AddNewCard(a:listId, UrlEncode(l:userInput))
  call GetCardsById(a:listId, a:boardId)
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

  let l:cardId = g:common#GetIdFromDictList(g:taskDictList, a:cardName[0])
  let l:cmd = g:command#DeleteCardCmd(l:cardId)
  call system(l:cmd)
  call GetCardsById(a:listId, a:boardId)

endfunction

" get single card
function! GetSingleCard(cardName, listId, boardId)

  try
    call s:CheckSelectedLine(a:cardName[0])
  catch
    echomsg v:exception
    return
  endtry

  let l:cardId = g:common#GetIdFromDictList(g:taskDictList, a:cardName[0])
  let l:cmd = g:command#GetSingleCardCmd(l:cardId)

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:desc = g:common#GetDescFromRes(l:result)
  if l:desc == ""
    echomsg "no description on this Task"
  endif

  call g:task_detail#OpenSingleCardNewBuffer(l:desc, a:listId, a:boardId)

endfunction

function! s:CheckSelectedLine(char)
  let l:err_msg = "cannot select here."
  if a:char == ""
    throw l:err_msg
  endif
  for task in g:taskDictList
    if a:char == task.id
      return
    endif
  endfor
  throw l:err_msg
endfunction

function! EditCardTitle(cardName, listId, boardId)

  if a:cardName == ""
    return
  endif

  let l:cardId = g:common#GetIdFromLine(a:cardName)
  let l:cardTitle = g:common#GetTitleFromLine(a:cardName)

  call inputsave()
  let l:userInput = input("Edit title of the card.\nTask name: ", l:cardTitle)
  call inputrestore()

  let l:cmd = g:command#UpdateCardTitleCmd(l:cardId, UrlEncode(l:userInput))

  call system(l:cmd)
  call GetCardsById(a:listId, a:boardId)

endfunction
