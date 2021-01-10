" =================================
" commands
" =================================
function! g:command#GetBoardsCmd()
  let l:path = "/1/members/me/boards"
  let l:url = s:BuildTrelloApiUrl(l:path)
  return  g:curl#CurlGetCmd(l:url)
endfunction

function! g:command#GetListsCmd(boardId)
  let l:path = "/1/boards/" . a:boardId . "/lists"
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! g:command#GetCardsCmd(listId)
  let l:path = "/1/lists/" . a:listId . "/cards"
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! g:command#GetSingleCardCmd(cardId)
  let l:path = "/1/cards/" . a:cardId
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! g:command#AddNewCardCmd(listId, title)
  let l:path = "/1/cards"
  let l:absolute_url = g:common#AddPostParams(s:BuildTrelloApiUrl(l:path), a:listId, a:title)
  return  g:curl#CurlPostCmd(l:absolute_url)
endfunction

function! g:command#DeleteCardCmd(cardId)
  let l:path = "/1/cards/" . a:cardId
  return  g:curl#CurlDeleteCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:BuildTrelloApiUrl(path)
  return "https://api.trello.com" . a:path . "?key=" . g:vimTrelloApiKey . "&token=" . g:vimTrelloToken
endfunction
