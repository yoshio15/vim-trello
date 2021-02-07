" =================================
" Tasks
" =================================
function! g:task#OpenCardsNewBuffer(listDict, listId, boardId)

  let cards_buffer = 'CARDS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(cards_buffer)

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

  let list_name = g:common#GetNameByIdFromList(a:listId, g:listDictList)
  let explanations = [
        \ '(a)dd new Task',
        \ '(b)ack to Lists',
        \ '(d)elete a Task',
        \ '(e)dit the title of Task',
        \ '(q) close buffer',
        \ '(Enter) show detail of Task',
        \ '',
        \ printf('List: %s', list_name)
        \ ]
  call setbufline(cards_buffer, 1, explanations)
  call g:common#WriteDictListToBuf(g:taskDictList)

  call cursor(11, 1)
  setlocal nomodifiable

endfunction


function! OpenAddNewTaskArea(listId, boardId)
  " accept user input
  call inputsave()
  let userInput=input("Enter title of card which you want to add.\nTask name: ")
  call inputrestore()

  if trim(userInput) == ''
    return
  endif

  call AddNewCard(a:listId, UrlEncode(userInput))
  call GetCardsById(a:listId, a:boardId)
endfunction


" add single card
function! AddNewCard(listId, title)
  let cmd = g:command#AddNewCardCmd(a:listId, a:title)
  call system(cmd)
endfunction


" delete card
function! DeleteCard(cardName, listId, boardId)
  let lineId = trim(getline("."))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry

  call inputsave()
  let userInput=input(printf("Are you sure to delete the task:\n%s(yN): ", a:cardName))
  call inputrestore()

  if userInput ==? "y"
    let cardId = g:common#GetIdFromDictList(g:taskDictList, lineId)
    let cmd = g:command#DeleteCardCmd(cardId)
    call system(cmd)
    call GetCardsById(a:listId, a:boardId)
  else
    echomsg "not deleted task."
  endif
endfunction

" get single card
function! GetSingleCard(cardName, listId, boardId)

  try
    call s:CheckSelectedLine(a:cardName[0])
  catch
    echomsg v:exception
    return
  endtry

  let cardId = g:common#GetIdFromDictList(g:taskDictList, a:cardName[0])
  let cmd = g:command#GetSingleCardCmd(cardId)

  try
    let result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let desc = g:common#GetDescFromRes(result)
  if desc == ""
    echomsg "no description on this Task"
  endif

  call g:task_detail#OpenSingleCardNewBuffer(desc, a:listId, a:boardId)

endfunction

function! s:CheckSelectedLine(char)
  let err_msg = "cannot select here."
  if a:char == ""
    throw err_msg
  endif
  for task in g:taskDictList
    if a:char == task.id
      return
    endif
  endfor
  throw err_msg
endfunction

function! EditCardTitle(cardName, listId, boardId)

  if a:cardName == ""
    return
  endif

  let cardId = g:common#GetIdFromDictList(g:taskDictList, a:cardName[0])
  let cardTitle = g:common#GetTitleFromLine(a:cardName)

  call inputsave()
  let userInput = input("Edit title of the card.\nTask name: ", cardTitle)
  call inputrestore()

  let cmd = g:command#UpdateCardTitleCmd(cardId, UrlEncode(userInput))

  call system(cmd)
  call GetCardsById(a:listId, a:boardId)

endfunction
