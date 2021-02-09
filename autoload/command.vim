" =================================
" commands
" =================================
function! g:command#GetBoardsCmd()
  let path = "/1/members/me/boards"
  let url = s:BuildTrelloApiUrl(path)
  return  g:curl#CurlGetCmd(url)
endfunction

function! g:command#GetListsCmd(boardId)
  let path = printf("/1/boards/%s/lists", a:boardId)
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(path))
endfunction

function! g:command#GetCardsCmd(listId)
  let path = printf("/1/lists/%s/cards", a:listId)
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(path))
endfunction

function! g:command#AddNewListCmd(boardId, title)
  let path = "/1/lists"
  let absolute_url = s:BuildTrelloApiUrl(path) . '&idBoard=' . a:boardId . '&name=' . a:title
  return  g:curl#CurlPostCmd(absolute_url)
endfunction

function! g:command#DeleteListCmd(listId)
  let path = printf("/1/lists/%s/closed", a:listId)
  let absolute_url = s:BuildTrelloApiUrl(path) . '&value=true'
  return  g:curl#CurlPutCmd(absolute_url)
endfunction

function! g:command#GetSingleCardCmd(cardId)
  let path = printf("/1/cards/%s", a:cardId)
  return  g:curl#CurlGetCmd(s:BuildTrelloApiUrl(path))
endfunction

function! g:command#UpdateCardTitleCmd(cardId, title)
  let path = printf("/1/cards/%s", a:cardId)
  let absolute_url = s:BuildTrelloApiUrl(path) . '&name=' . a:title
  return  g:curl#CurlPutCmd(absolute_url)
endfunction

function! g:command#UpdateCardDescCmd(cardId, desc)
  let path = printf("/1/cards/%s", a:cardId)
  let absolute_url = s:BuildTrelloApiUrl(path) . '&desc=' . a:desc
  return  g:curl#CurlPutCmd(absolute_url)
endfunction

function! g:command#AddNewCardCmd(listId, title)
  let path = "/1/cards"
  let absolute_url = g:common#AddPostParams(s:BuildTrelloApiUrl(path), a:listId, a:title)
  return  g:curl#CurlPostCmd(absolute_url)
endfunction

function! g:command#DeleteCardCmd(cardId)
  let path = printf("/1/cards/%s", a:cardId)
  return  g:curl#CurlDeleteCmd(s:BuildTrelloApiUrl(path))
endfunction

function! s:BuildTrelloApiUrl(path)
  return printf("https://api.trello.com%s?key=%s&token=%s", a:path, g:vimTrelloApiKey, g:vimTrelloToken)
endfunction
