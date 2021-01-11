" =================================
" 【Common functions】
" =================================
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

function! g:common#GetTitleFromLine(line)
  return a:line[0 : stridx(a:line,'(') - 1]
endfunction

function! g:common#GetIdAndNameDictFromResList(responseList)
  let l:dict = {}
  for response in a:responseList
    let l:dict[response['id']] = response['name']
  endfor
  return l:dict
endfunction

function! g:common#GetDescFromRes(response)
  let l:desc = 'desc'
  if has_key(a:response, l:desc)
    return a:response[l:desc]
  endif
  return ''
endfunction

function! g:common#WriteDictToBuf(dict)
  call append(0, '----------------------------')
  for key in keys(a:dict)
    let l:row = a:dict[key] . "(" . key . ")"
    call append(line(0), l:row)
  endfor
  call append(0, '----------------------------')
endfunction

function! g:common#AddPostParams(url, idList, name)
  let l:absolute_url = a:url
  if a:idList == ""
    throw  "param 'idList' is required to add new Card"
  endif
  if a:name != ""
    let l:absolute_url = l:absolute_url .  "&name=" . a:name
  endif
  let l:absolute_url = l:absolute_url . "&idList=" . a:idList
  return l:absolute_url
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
  execute 50 'vnew' a:bufName
endfunction

function! g:common#WriteTitleToBuf(title)
  call append(0, a:title)
  call append(1, '')
endfunction
