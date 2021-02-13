" =================================
" 【Main】vim-trello
" =================================
let g:boardDictList = []
let g:listDictList = []
let g:taskDictList = []

function! g:trello#VimTrello()
  try
    call g:common#CheckEnv()
  catch
    echomsg v:exception
    return
  endtry

  call trello#SetBoardList()
  call g:board#OpenBoardsNewBuffer()
endfunction

function! trello#SetBoardList() abort
  let path = "/1/members/me/boards"
  let url = common#BuildTrelloApiUrl(path)
  let response = http#Get(url)

  if response['status'] == 200
    try
      let result = json_decode(response['content'])
    catch
      throw v:exception
    endtry
    " set board list to global
    let g:boardDictList = g:common#GetBoardDictListFromResList(result)
    return
  endif

  throw response['content']
endfunction
