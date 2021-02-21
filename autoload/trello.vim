" =================================
" 【Main】vim-trello
" =================================
let g:boardDictList = []
let g:listDictList = []
let g:taskDictList = []
let g:BUFFER_WIDTH_HYPHEN = '----------------------------------------------'

function! g:trello#VimTrello()
  try
    call g:common#CheckEnv()
  catch
    echomsg v:exception
    return
  endtry

  call board#SetBoardList()
  call g:board#OpenBoardsNewBuffer()
endfunction
