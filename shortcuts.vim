" This file contains keybindings
" Learn more about mapping keys in vim here: 

" Modifier Key Encodings
" Raw key sequences look a bit weird, to understand this mapping,
" Check out: https://github.com/mintty/mintty/wiki/Keycodes#modifier-key-encodings

" Understanding complex raw key bindings that use arrows
" Up      OA
" Down    OB
" Right   OC
" Left    OD
" Ctrl UDRL [1;5A [1;5B [1;5C [1;5D

" Shift U [1;2A
" Alt U [1;3A
" Shift Alt U [1;4A
" Ctrl U [1;5A
" Shift Ctrl U [1;6A
" Ctrl Alt U [1;7A
" Shift Ctrl Alt U [1;8A

" ==== File ====

" Save file <-> Ctrl + S
"
" In your .bashrc add:
"   stty -ixon
"
imap <C-s> <esc>:w<CR>a
map <C-s> :w<CR>

" Shortcuts Help - Shift + F1
imap [1;2P <esc>:split ~/.vim/doc/josh.txt<cr>
map [1;2P :split ~/.vim/doc/josh.txt<cr>


" ==== Navigate ====
" Next tab - gt in normal mode

" ==== Selection ====
" These mappings are pretty standard in everything but Vim/Emacs

" Shift + Up
inoremap [1;2A <esc>vk
noremap [1;2A vk
vnoremap [1;2A k

" Shift + Down
inoremap [1;2B <esc>vj
noremap [1;2B vj
vnoremap [1;2B j

" Shift + Right
inoremap [1;2C <esc>vl
noremap [1;2C vl
vnoremap [1;2C l

" Shift + Left
inoremap [1;2D <esc>vh
noremap [1;2D vh
vnoremap [1;2D h

" Shift + Ctrl + Left
inoremap [1;6D <esc>vb
nnoremap [1;6D vb
vnoremap [1;6D b

" Shift + Ctrl + Right
inoremap [1;6C <esc>vw
nnoremap [1;6C vw
vnoremap [1;6C w

" ==== Basic ====
" Normal key mappings in everything but vim/emacs
vnoremap <C-C> y
vnoremap <C-X> d
nnoremap <C-Q> 
nnoremap <C-V> p

" ==== Edit =====

" Undo - Ctrl + U
noremap <C-z> u
inoremap <C-z> <esc>ui

" Redo - Ctrl + R
inoremap <C-r> <esc><C-r>a

" Find - Ctrl + F
inoremap <C-f> <esc>/
nnoremap <C-f> /

" Replace - Shift + Ctrl + F
inoremap  <esc>:%s///gc<left><left><left><left>
nnoremap  :%s///gc<left><left><left><left>

" Duplicate Line - Shift + Ctrl + D
inoremap  <Esc>yypi
nnoremap  yyp
vnoremap  yPgv


" Indent - Tab
" Unindent - Shift + Tab
inoremap <S-Tab> <Esc><<i
nnoremap <Tab> >> 
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" ==== View ====

" Show/Hide Project Tree - Alt + 1
map 1 :NERDTreeToggle<CR>
imap 1 <esc>:NERDTreeToggle<CR>

" Show/Hide Outline - Alt + 7
map 7 :TagbarToggle<CR>
imap 7 <esc>:TagbarToggle<CR>

" ==== Navigate ====

" Header/Source switcher for C/C++
fun! SwapHeaderSource()
  let $f = bufname("")
  let suffixes = ['.c', '.cc', '.cpp']
  
  if matchend($f, '.h') > 0
    let base = strpart($f, 0, strlen($f) - 2)
    for end in suffixes
      if filereadable(base . end)
        let $f = base . end
        break
      endif
    endfor
  else
    for end in suffixes
      if matchend($f, end) > 0
        let base = strpart($f, 0, strlen($f) - strlen(end))
        if filereadable(base . ".h")
          let $f = base . ".h"
        endif
        break
      endif
    endfor
  endif

  if $f != bufname("")
    find $f
  else
    echo "Unable to finding a matching header/source file for " $f
  endif
endf

map <F2> :call SwapHeaderSource()<CR>


function! CtrlB()
  try
    exe "tag " . expand("<cfile>")
"     normal gf
  catch /^Vim\%((\a\+)\)\=:E447/
    exe "tag " . expand("<cword>")
  endtry
endfunction
" Go to Definition - Ctrl + B
map <C-B> :call CtrlB()<CR>
"exe "tag " . expand("<cword>") <CR>
imap <C-B> <esc><C-B>

" Go to Line Number - Ctrl + G
inoremap <C-g> <Esc>:
nnoremap <C-g> :

" ==== Code ====

" Surround with - Shift + Ctrl + T
" Followed by:
"   "'`)}]>  for surrounding the word/selection with the appropriate pair
"   ([{  do the same but with whitespace within the surrounding pair
"
" Note that you'll have to type a or i to go back to insert mode
imap  <esc>ysiw
map  ysiw
vmap  S



" Fold/Unfold


" Insert Snippet? TODO


" Comment/Uncomment
" Mapping: Ctrl + /
" Bundle: 'scrooloose/nerdcommenter'
imap <C-_> <esc><leader>c<Space>gi
map <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>gv

" Reformat Code
" Mapping: Ctrl + Alt + L
" Bundle: google/vim-codefmt
inoremap  <esc>:FormatCode<cr>gi
noremap  <esc>:FormatCode<cr>
vnoremap  <esc>:FormatLines<cr>gv

" Auto Indent
" Mapping: Shift + Ctrl + I
inoremap  <esc>==gi
noremap  ==
vnoremap  =gv

" Shift+Ctrl+Down - move the line one down
inoremap [1;6B <Esc>:m .+1<CR>==gi
nnoremap [1;6B :m .+1<CR>==
vnoremap [1;6B :m '>+1<CR>gv=gv

" Shift+Ctrl+Up - move the line one up
inoremap [1;6A <Esc>:m .-2<CR>==gi
nnoremap [1;6A :m .-2<CR>==
vnoremap [1;6A :m '<-2<CR>gv=gv

" Shift+Ctrl+Down - move the line one down
inoremap [1;7B <Esc>:m .+1<CR>==gi
nnoremap [1;7B :m .+1<CR>==
vnoremap [1;7B :m '>+1<CR>gv=gv

" Shift+Ctrl+Up - move the line one up
inoremap [1;7A <Esc>:m .-2<CR>gi
nnoremap [1;7A :m .-2<CR>
vnoremap [1;7A :m '<-2<CR>gv
