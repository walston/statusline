hi StatusLine ctermbg=232
hi StatusLineNC ctermfg=0 ctermbg=233 cterm=none
hi StatusLineBufferNumber ctermbg=232 ctermfg=12 cterm=bold
hi StatusLineFileName ctermbg=232 ctermfg=10
hi StatusLineAuxData ctermbg=232 ctermfg=6
hi StatusLineGitInfo ctermbg=232 ctermfg=5
hi StatusLineGitBranch ctermbg=232 ctermfg=1 cterm=bold
hi ColorColumn ctermbg=234 ctermfg=none

function! Git() " Gets the git branch name for statusline
  let l:folder=expand('%:p:h')
  let l:branch=system('git -C '.l:folder.' rev-parse --abbrev-ref HEAD')
  if (match(l:branch,'^fatal:',) < 0)
    return substitute(l:branch,'\n','','')
  else
    return ''
  endif
endfunction

if has('statusline')
  let s:GitBranch=Git()
  set statusline=%#StatusLineBufferNumber#     " set highlighting
  set statusline+=%5.5n\                       " buffer number
  if (strlen(s:GitBranch)>0)
    set statusline+=%#StatusLineGitInfo#
    set statusline+=⑆
    set statusline+=%#StatusLineGitBranch#
    set statusline+=%{Git()}
    set statusline+=%#StatusLineGitInfo#
    set statusline+= \                         " set Git branch
  endif
  set statusline+=%#StatusLineFileName#        " set highlighting
  set statusline+=%t\                          " file name
  set statusline+=%#StatusLineAuxData#         " set highlighting
  set statusline+=%h%m%r%w\                    " flags
  set statusline+=%{strlen(&ft)?&ft:'none'},   " file type
  set statusline+=%{(&fenc==\"\"?&enc:&fenc)}, " encoding
  set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
  set statusline+=%{&fileformat},              " file format
  set statusline+=%{&spelllang},               " language of spelling checker
  set statusline+=%=                           " ident to the right
  set statusline+=0x%-8B\                      " character code under cursor
  set statusline+=@%-7.(%l,%c%V%)\ %<%P        " cursor position/offset
endif

augroup CursorLine
  au!
  au VimEnter * setlocal cursorline
  au WinEnter * setlocal cursorline
  au BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
