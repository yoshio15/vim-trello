" Curl
" Author: ykondo
" License: MIT

function! g:curl#CurlGetCmd(url)
  return printf("curl -s --request GET --url \'%s\'", a:url)
endfunction

function! g:curl#CurlPostCmd(url)
  return printf("curl -s --request POST --url \'%s\'", a:url)
endfunction

function! g:curl#CurlPutCmd(url)
  return printf("curl -s --request PUT --url \'%s\'", a:url)
endfunction

function! g:curl#CurlDeleteCmd(url)
  return printf("curl -s --request DELETE --url \'%s\'", a:url)
endfunction
