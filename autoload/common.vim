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

function! g:common#GetIdAndNameDictFromResList(responseList)
  let l:dict = {}
  for response in a:responseList
    let l:dict[response['id']] = response['name']
  endfor
  echomsg l:dict
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
  echomsg keys(a:dict)
  for key in keys(a:dict)
    let l:row = a:dict[key] . "(" . key . ")"
    call append(line(0), l:row)
    echomsg l:row
  endfor
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


" =================================
" manipulate buffer
" =================================
function! g:common#CloseBuf()
  execute 'bwipeout'
endfunction

function! g:common#OpenNewBuf(bufName)
  execute 50 'vnew' a:bufName
endfunction
