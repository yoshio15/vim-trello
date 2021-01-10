" =================================
" curl commands
" =================================
function! g:curl#CurlGetCmd(url)
  return "curl -s --request GET --url '" . a:url . "'"
endfunction

function! g:curl#CurlPostCmd(url)
  return "curl -s --request POST --url '" . a:url . "'"
endfunction

function! g:curl#CurlPutCmd(url)
  return "curl -s --request PUT --url '" . a:url . "'"
endfunction

function! g:curl#CurlDeleteCmd(url)
  return "curl -s --request DELETE --url '" . a:url . "'"
endfunction
