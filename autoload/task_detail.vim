" =================================
" Detail of a Task
" =================================
let s:NO_TASK_DESCRIPTION = "no task description"

function! g:task_detail#OpenSingleCardNewBuffer(desc, listId, boardId, cardId)

  let single_card_buffer = 'CARD'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(single_card_buffer)

  exec 'nnoremap <silent> <buffer> <Plug>(get-cards) :<C-u>call list#GetCardsById("' . a:listId . '", "' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(close-buf) :<C-u>bwipeout!<CR>
  nmap <buffer> b <Plug>(get-cards)
  nmap <buffer> q <Plug>(close-buf)

  let task_name = g:common#GetNameByIdFromList(a:cardId, g:taskDictList)
  let lines = [
        \ '(b)ack to Cards',
        \ '(q) close buffer',
        \ '(:w) edit description of the task',
        \ '',
        \ printf('Task: %s', task_name),
        \ g:BUFFER_WIDTH_HYPHEN,
        \ a:desc == '' ? s:NO_TASK_DESCRIPTION : a:desc,
        \ g:BUFFER_WIDTH_HYPHEN,
        \ ]
  call setbufline(single_card_buffer, 1, lines)

  call cursor(len(lines)+1, 1)

  augroup task-detail
    au!
    exec 'au BufWriteCmd <buffer> call s:UpdateTaskDetail("' . a:cardId . '", "' . a:listId . '", "' . a:boardId . '")'
  augroup END

endfunction

function! s:UpdateTaskDetail(cardId, listId, boardId)
  let desc = join(getline(7, line("$")-1), '')
  if desc == s:NO_TASK_DESCRIPTION
    return
  endif

  let cmd = g:command#UpdateCardDescCmd(a:cardId, UrlEncode(desc))
  call system(cmd)
  echomsg "updated task detail."
endfunction
