" forked from http://qiita.com/naoty_k/items/56eddc9b76fe630f9be7

" todoリストを簡単に入力する
abbreviate tl - [ ]

"" 入れ子のリストを折りたたむ
"setlocal foldmethod=expr foldexpr=MkdCheckboxFold(v:lnum) foldtext=MkdCheckboxFoldText()
"function! MkdCheckboxFold(lnum)
"    let line = getline(a:lnum)
"    let next = getline(a:lnum + 1)
"    if MkdIsNoIndentCheckboxLine(line) && MkdHasIndentLine(next)
"        return 1
"    elseif (MkdIsNoIndentCheckboxLine(next) || next =~ '^$') && !MkdHasIndentLine(next)
"        return '<1'
"    endif
"    return '='
"endfunction
"function! MkdIsNoIndentCheckboxLine(line)
"    return a:line =~ '^- \[[ x]\] '
"endfunction
"function! MkdHasIndentLine(line)
"    return a:line =~ '^[[:blank:]]\+'
"endfunction
"function! MkdCheckboxFoldText()
"    return getline(v:foldstart) . ' (' . (v:foldend - v:foldstart) . ' lines) '
"endfunction

" todoリストのon/offを切り替える
nnoremap <buffer> <Leader><Leader> :call ToggleCheckbox()<CR>
vnoremap <buffer> <Leader><Leader> :call ToggleCheckbox()<CR>

" 選択行のチェックボックスを切り替える
function! ToggleCheckbox()
  let l:line = getline('.')
  if l:line =~ '\-\s\[\s\]'
    " 完了時刻を挿入する
    let l:result = substitute(l:line, '-\s\[\s\]', '- [x]', '') . ' [' . strftime("%Y/%m/%d (%a) %H:%M") . ']'
    call setline('.', l:result)

    "le l:nextLine = getline(a:line)
    "ToggleCheckboxLine(l:nextLine)

  elseif l:line =~ '\-\s\[x\]'
    let l:result = substitute(substitute(l:line, '-\s\[x\]', '- [ ]', ''), '\s\[\d\{4}.\+]$', '', '')
    call setline('.', l:result)
  end
endfunction

syntax match mkdcheckboxmark /.*-\s\[x\]\s.\+/ display containedin=all
highlight mkdcheckboxmark guifg=#A6E22E
syntax match mkdcheckboxunmark /.*-\s\[\s\]\s.\+/ display containedin=all
highlight mkdcheckboxunmark guifg=#F92672
