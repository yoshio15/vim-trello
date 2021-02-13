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

  let boardDict = s:GetBoards()
  call g:board#OpenBoardsNewBuffer(boardDict)
endfunction

function! s:GetBoards() abort
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
    return g:common#GetIdAndNameDictFromResList(result)
  endif

  throw response['content']
endfunction
