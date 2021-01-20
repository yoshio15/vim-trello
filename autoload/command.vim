" =================================
" commands
" =================================
function! g:command#GetBoardsCmd()
  let l:path = "/1/members/me/boards"
  let l:url = s:BuildTrelloApiUrl(l:path)
  return  g:curl#CurlGetCmd(l:url)
endfunction

function! g:command#GetListsCmd(boardId)
  let l:path = printf("/1/boards/%s/lists", a:boardId)
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! g:command#GetCardsCmd(listId)
  let l:path = printf("/1/lists/%s/cards", a:listId)
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! g:command#AddNewListCmd(boardId, title)
  let l:path = "/1/lists"
  let l:absolute_url = s:BuildTrelloApiUrl(l:path) . '&idBoard=' . a:boardId . '&name=' . a:title
  return  g:curl#CurlPostCmd(l:absolute_url)
endfunction

function! g:command#DeleteListCmd(listId)
  let l:path = printf("/1/lists/%s/closed", a:listId)
  let l:absolute_url = s:BuildTrelloApiUrl(l:path) . '&value=true'
  return  g:curl#CurlPutCmd(l:absolute_url)
endfunction

function! g:command#GetSingleCardCmd(cardId)
  let l:path = printf("/1/cards/%s", a:cardId)
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! g:command#UpdateCardTitleCmd(cardId, title)
  let l:path = printf("/1/cards/%s", a:cardId)
  let l:absolute_url = s:BuildTrelloApiUrl(l:path) . '&name=' . a:title
  return  g:curl#CurlPutCmd(l:absolute_url)
endfunction

function! g:command#AddNewCardCmd(listId, title)
  let l:path = "/1/cards"
  let l:absolute_url = g:common#AddPostParams(s:BuildTrelloApiUrl(l:path), a:listId, a:title)
  return  g:curl#CurlPostCmd(l:absolute_url)
endfunction

function! g:command#DeleteCardCmd(cardId)
  let l:path = printf("/1/cards/%s", a:cardId)
  return  g:curl#CurlDeleteCmd(s:BuildTrelloApiUrl(l:path))
endfunction

function! s:BuildTrelloApiUrl(path)
  return printf("https://api.trello.com%s?key=%s&token=%s", a:path, g:vimTrelloApiKey, g:vimTrelloToken)
endfunction
