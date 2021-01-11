" =================================
" Detail of a Task
" =================================
function! g:task_detail#OpenSingleCardNewBuffer(desc, listId, boardId)

  if a:desc == ""
    return
  endif

  let l:single_card_buffer = 'CARD'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:single_card_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(get-cards) :<C-u>call GetCardsById("' . a:listId . '", "' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(close-buf) :<C-u>bwipeout!<CR>
  nmap <buffer> b <Plug>(get-cards)
  " TODO add edit description of task function
  " nmap <buffer> e <Plug>(edit-card)
  nmap <buffer> q <Plug>(close-buf)

  let l:desc_b_key = '(b)ack to Cards'
  let l:desc_q_key = '(q) close buffer'

  call setline(1, a:desc)
  call g:common#WriteTitleToBuf('[Detail of a TASK]')
  call append(0, '')
  call append(0, '============================')
  call append(0, l:desc_q_key)
  call append(0, l:desc_b_key)
  call append(0, '========= key map ==========')

endfunction


function! EditCardDesc()
endfunction
