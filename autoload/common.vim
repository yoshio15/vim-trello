" =================================
" 【Common functions】
" =================================
let s:buffer_with = 50

function! g:common#CheckEnv()
  if !executable('curl')
    throw "curl is not available"
  endif
  if !exists('g:vimTrelloApiKey')
    throw "g:apiKey is not difined in your vimrc"
  endif
  if !exists('g:vimTrelloToken')
    throw "g:token is not difined in your vimrc"
  endif
endfunction

function! g:common#GetIdFromLine(line)
  return a:line[stridx(a:line,'(') + 1 : stridx(a:line,')') - 1]
endfunction

function! g:common#GetIdFromDictList(dictList, id)
  for item in a:dictList
    if !has_key(item, "id") || !has_key(item, "boardId")
      continue
    endif
    if item.id == a:id
      return item.boardId
    endif
  endfor
  return ""
endfunction

function! g:common#GetTitleFromLine(line)
  return a:line[stridx(a:line, ' ') + 1 : strlen(a:line)]
endfunction

function! g:common#GetIdAndNameDictFromResList(responseList)
  let dict = {}
  for response in a:responseList
    let dict[response['id']] = response['name']
  endfor
  return dict
endfunction

function! g:common#GetBoardDictListFromResList(responseList)
  let boardDictList = []
  let id = 1
  for response in a:responseList
    let boardDict = {
          \ "id": id,
          \ "boardId" : response['id'],
          \ "name": response['name']
          \ }
    let id += 1
    call add(boardDictList, boardDict)
  endfor
  return boardDictList
endfunction

function! g:common#GetDescFromRes(response)
  let desc = 'desc'
  if has_key(a:response, desc)
    return a:response[desc]
  endif
  return ''
endfunction

function! g:common#GetNameByIdFromList(id, list)
  for board in a:list
    if board['boardId'] == a:id
      return board['name']
    endif
  endfor
endfunction

function! g:common#WriteDictToBuf(dict)
  call append(0, '----------------------------')
  for key in keys(a:dict)
    let row = a:dict[key] . "(" . key . ")"
    call append(line(0), row)
  endfor
  call append(0, '----------------------------')
endfunction

function! g:common#WriteDictListToBuf(dictList)
  call append(line("$"), s:GetLineOfBufWidth())
  for item in a:dictList
    if !has_key(item, "id") || !has_key(item, "name")
      continue
    endif
    let row = printf("%d\. %s", item["id"], item["name"])
    call append(line("$"), row)
  endfor
  call append(line("$"), s:GetLineOfBufWidth())
endfunction

function! g:common#AddPostParams(url, idList, name)
  let absolute_url = a:url
  if a:idList == ""
    throw  "param 'idList' is required to add new Card"
  endif
  if a:name != ""
    let absolute_url = absolute_url .  "&name=" . a:name
  endif
  let absolute_url = absolute_url . "&idList=" . a:idList
  return absolute_url
endfunction

function! s:GetLineOfBufWidth()
  let line_char = "-"
  let char_list = []
  for el in range(s:buffer_with - 4)
    call add(char_list, line_char)
  endfor
  return join(char_list, '')
endfunction

" URL encode a string. ie. Percent-encode characters as necessary.
function! UrlEncode(string)
  let result = ""
  let characters = split(a:string, '.\zs')
  for character in characters
    if character == " "
      let result = result . "+"
    elseif s:CharacterRequiresUrlEncoding(character)
      let i = 0
      while i < strlen(character)
        let byte = strpart(character, i, 1)
        let decimal = char2nr(byte)
        let result = result . "%" . printf("%02x", decimal)
        let i += 1
      endwhile
    else
        let result = result . character
    endif
  endfor
  return result
endfunction

" Returns 1 if the given character should be percent-encoded in a URL encoded string.
function! s:CharacterRequiresUrlEncoding(character)
  let ascii_code = char2nr(a:character)
  if ascii_code >= 48 && ascii_code <= 57
    return 0
  elseif ascii_code >= 65 && ascii_code <= 90
    return 0
  elseif ascii_code >= 97 && ascii_code <= 122
    return 0
  elseif a:character == "-" || a:character == "_" || a:character == "." || a:character == "~"
    return 0
  endif
  return 1
endfunction


" =================================
" manipulate buffer
" =================================
function! g:common#CloseBuf()
  execute 'bwipeout'
endfunction

function! g:common#OpenNewBuf(bufName)
  execute s:buffer_with 'vnew' a:bufName
endfunction
