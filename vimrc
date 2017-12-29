" Your vimrc defines the commands to execute whenever you open vim
" These are some of the most useful settings

" Where the vim plugins are stored
" set rtp=$HOME/config/vim

" *** SETTINGS ***
set tabstop=2           " tabs appear as 2 spaces
set shiftwidth=2        " Indentation width when shifting
set expandtab           " tabs are expanded to spaces
match Error '\%>120v.\+' " Mark lines that are too long as errors
set hlsearch            " when searching, highlight results
set incsearch           " search as I type
set smartindent         " auto indentation
set number              " turns on line numbers. Turn on with :set nonumber
set ruler               " turns on row, column number in status line
set virtualedit=onemore " cursor can go one past end of line
set t_Co=256            " use 256 colors
set completeopt-=preview
set t_ut=               " For vim backgrounds to appear properly inside of tmux
set mouse=a             " use the mouse to navigate around as well
set nocompatible
syntax on               " Turn on highlighting
" set scrolloff=20

" Personal color scheme for syntax highlighting (Including C/C++ stuff)
" Located at cs.uw.edu/homes/jrios777/molokai.vim
" Place in your ~/.vim/colors/ folder (create the folder if it doesn't exist)
colorscheme molokai

" *** Better Completion! ***
" Maps the Enter key to behave properly with auto completion and maps CTRL+SPACE
" to bring up auto completion.
" Check out http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
" omniSwitch switches between omni and regular completion depending on
" availability
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? '<C-y>' : "\<C-g>u\<CR>" | let g:completionLevel=0
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
let completionLevel=0

function! CustomComplete(findstart, base)
  if a:findstart
    let synres = syntaxcomplete#Complete(a:findstart, a:base)
    let omnires = function(&omnifunc)(a:findstart, a:base)
    return synres < 0 ? omnires : synres
"     echo "syn". syntaxcomplete#Complete(a:findstart, a:base)
"     echo "oni". function(&omnifunc)(a:findstart, a:base)
"     return syntaxcomplete#Complete(a:findstart, a:base)
"     return function(&omnifunc)(a:findstart, a:base)
  else
"     echo a:base
"     echo "sdf" . [2]
  let res = syntaxcomplete#Complete(a:findstart, a:base)
  if &omnifunc != ""
    let omnires = function(&omnifunc)(a:findstart, a:base)
    for entry in omnires
      let res += [entry['word']]
    endfor
  endif
  return res
endfunction

function! InvokeComplete()
  let expr = ''

  if g:completionLevel == 1 && &completefunc != ""
    let expr .= "\<Esc>a\<C-x>\<C-u>"
    let g:completionLevel=2
  elseif g:completionLevel == 2 && &omnifunc != ""
    let expr .= "\<Esc>a\<C-x>\<C-o>" 
    let g:completionLevel=3
  else
    let expr .= "\<Esc>a\<C-p>"
    let g:completionLevel=1
  endif

  "<C-r>= has special meaning in vim script
  "=pumvisible() ? "\<Down>" : ""
  let expr .= "\<C-r>=pumvisible() ? "
  let expr .= '"\<Down>" '
  let expr .= ": ''\<CR>"

  return expr
endfunction
imap <C-@> <C-Space>
inoremap <expr> <C-Space> InvokeComplete()

" Turn on syntax completion if possible
" if has("autocmd") && exists("+omnifunc")
"   autocmd Filetype *
"           \ if &omnifunc == "" |
"           \   setlocal omnifunc=syntaxcomplete#Complete |
"           \ endif
" endif

" When opening from a quick fix list either go to it or split the window and
" open the corresponding file
set switchbuf=usetab,split

" Detect Go files!
au BufRead,BufNewFile *.go set ft=go

" Diff scheme for PHP
au BufReadPost *.php colorscheme monokai

" treat json like python and 401 like lua
autocmd BufNewFile,BufRead *.json set ft=python

" Function and Command for deleting trailing whitespace!
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunction

command! DeleteWhitespace call DeleteTrailingWS()

" *** PLUGINS ***
" Look into Vundle: http://vimawesome.com/plugin/vundle-vim-enchanted
" Vundle makes it easy to install vim plugins
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" 1. Make vim pasting work properly!
Plugin 'conradirwin/vim-bracketed-paste'

" 2. Give auto completion suggestions on the go!
Plugin 'AutoComplPop'
" let g:acp_behaviorUserDefinedFunction=&completefunc
let g:acp_behaviorKeywordCommand = "\<C-n>"

" 3. C/C++ Completion!
Plugin 'Rip-Rip/clang_complete'
" path to directory where clang library can be found
let g:clang_library_path = $HOME . '/Downloads/clang/lib/libclang.so.3.8'

" 4. Autoclose matching character pairs! (I have a modded version of this to
" better accomodate when pressing <CR> in lexima#insmode#_expand(char) to check
" for pumvisible())
Plugin 'cohama/lexima.vim'
let g:lexima_map_escape='\<C-v>' " Lexima messes up <Esc> behavior if default

" 5. Code snippets for quick code generation!
Plugin 'msanders/snipmate.vim'
let g:acp_behaviorSnipmateLength=1

" 6. NerdTree! Make it easier to navigate around
Plugin 'scrooloose/nerdtree'
" Open it on vim enter!
au VimEnter *.* NERDTree | wincmd p
" Close it when it's the only thing left!
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 7. NerdCommenter! Smart commenting!
Plugin 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1 " Add spaces after comment delimiters
let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }  " // style
let g:NERDDefaultAlign = 'left' " Align line-wise comments to flush left
let g:NERDCommentEmptyLines = 1 " Allow commenting/inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting

" 8. Show Git Diff!
Plugin 'airblade/vim-gitgutter'

" For seamless tmux/vim split navigation
" Plugin 'christoomey/vim-tmux-navigator'

" Better search
" Plugin 'google/vim-searchindex'

" This plugin automatically formats code on save!
" pip install yapf
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plugin 'google/vim-glaive'

"One Dark Theme
Plugin 'rakr/vim-one'

" Awesome status line!
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme="one" 

" Catches syntax issuesV
" pip install pylint
Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_cpp_include_dirs = ['/homes/iws/jrios777/.local/include', '../proto', '../..', '../usr/include/', '/homes/iws/jrios777/usr/include/']

" All of your Plugins must be added before the following line
call vundle#end()            " required
" the glaive#Install() should go after the "call vundle#end()"
" call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
" Glaive codefmt plugin[mappings]
" Glaive codefmt google_java_executable="java -jar /path/to/google-java-format-VERSION-all-deps.jar"
filetype plugin indent on    " required

" For closing any previews
autocmd CompleteDone * pclose

" *** KEY MAPPINGS ***
" In vim you can map a key to do whatever you want in insert, normal, visual
" mode, etc. I write these to make life easier and vim more enjoyable to use. 
" Look into :help map for info on how to make your own mappings.
 
" Pressing F4 will search .h files in current directory for a match to the word
" under the cursor
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **/*.h" <Bar> cw<CR>
" map <F6> :execute "vimgrep /(typedef|/\\}|#define).*" . expand("<cword>") . "(;|/\\w)"/j *.h **/*.h *.c" <Bar> cw<CR>

" Look into ctags. "ctags -R ." in working directory.
" Pressing F3 will jump to where the word under the cursor was defined
map <F3> :execute "ptag " . expand("<cword>") <CR>
map <C-b> :exe "ptag " . expand("<cword>") <CR> 
imap <C-b> <Esc><C-b>

" (Unused) Custom functions for Tab and Shift-Tab
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return pumvisible() ? "\<C-N>" : "\<Tab>"
  else
    return "\<Tab>"
  endif
endfunction

function! Shift_Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return pumvisible() ? "\<C-P>" : "\<S-Tab>"
  else
    " left indent
    return "\<C-d>"
  endif
endfunction

" These mappings make Tab indent the line/selection and Shift-Tab unindent the
" line/selection. If the pop up menu is visible (auto completion) they grab the
" next/previous autocomplete selection
" Uncomment and use this if you'd like but I prefer to use Ctrl-Space 
" and use SnipMate for my Tab button instead in insert mode
" inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
" inoremap <S-Tab> <C-R>=Shift_Tab_Or_Complete()<CR>


" Maps shift + direction (h, j, k, l) to select for visual much like you'd do
" shift-arrow in an IDE
" In the case of up/down it selects entire lines, in the case of left/right it
" does a lowercase v selection
nmap K V<Up>
nmap J V<Down>
nmap H v<Left>
nmap L v<Right>
vmap K <Up>
vmap J <Down>
vmap H <Left>
vmap L <Right>

" Maps the shortcuts to enclose the cursor word/selection
" Works best when \n is not part of the selection
nmap "" wbi<C-V>"<Esc>ea<C-V>"
vmap "" di<C-V>"<Esc>pa<C-V>"
nmap "( wbi<C-V>(<Esc>ea<C-V>)
vmap "( di<C-V>(<Esc>pa<C-V>)
nmap "[ wbi<C-V>[<Esc>ea<C-V>]
vmap "[ di<C-V>[<Esc>pa<C-V>]
nmap "{ wbi<C-V>{<Esc>ea<C-V>}
vmap "{ di<C-V>{<Esc>pa<C-V>}
nmap "' wbi<C-V>'<Esc>ea<C-V>'
vmap "' di<C-V>'<Esc>pa<C-V>'

" Faster pane switching in normal mode: Go to pane in that direction
nmap <C-h> <C-w><Left>
nmap <C-j> <C-w><Down>
nmap <C-k> <C-w><Up>
nmap <C-l> <C-w><Right>
nmap <C-Left> <C-w><Left>
nmap <C-Down> <C-w><Down>
nmap <C-Up> <C-w><Up>
nmap <C-Right> <C-w><Right>

" Better editing/navigation
" Alt key mappings (Linux + Mac)

" Ctrl+g - go to line number
inoremap <C-g> <Esc>:
nnoremap <C-g> :

" Commenting blocks of code.
" Lets you easily press , to comment lines in insert/visual mode and . to uncomment
let b:comment_leader='# '  " default commenting for files
autocmd FileType c,cpp,java,javascript,go,proto    let b:comment_leader = '// '
autocmd FileType tex                        let b:comment_leader = '% '
autocmd FileType mail                       let b:comment_leader = '> '
autocmd FileType vim                        let b:comment_leader = '" '
noremap <silent> , :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> . :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" 333 HW3 Hex Tools!
" Use :Hex to hexdump a file
" Use :GoHex 0001 010f to go to file position 0x1010f
command! Hex %!xxd

function! GoToHex(p)
  let p = substitute(a:p, ' ', '', 'g')
  if strlen(p) == 5
    let p = p[1:]
  endif
  echo p
  let pos = str2nr(p, 16)
  let line_num = pos / 16
  let line_pos = pos % 16
  let line_offset = 10 + 2 * (line_pos % 2) + 5 * (line_pos / 2)
  exe 'goto' (line_num * 67 + line_offset)
  return ""
endfunction

command! -nargs=1 GoHex call GoToHex(<f-args>)

" automatically hexdump on .idx files
autocmd BufReadPost *.idx :silent Hex 

" Pressing F8 will take you to corresponding position if it's representable for
" numbers up to 0xffff! (Assumes it is a position)
map <F8> :execute "GoHex /" . expand("<cword>") <CR> 

" let g:tmux_navigator_no_mappings = 1
" 
" nnoremap <S-Left> :TmuxNavigateLeft<cr>
" nnoremap <silent> <lockserviceC-Down> :TmuxNavigateDown<cr>
" nnoremap <silent> <C-Up> :TmuxNavigateUp<cr>
" nnoremap <silent> <C-Right> :TmuxNavigateRight<cr>
" nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>

" For vim-codefmt
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" TODO: Come up with a better sourcing solution
source /homes/iws/jrios777/config/shortcuts.vim
