set showcmd	 " Show (partial) command in status line.
set showmatch  " Show matching brackets.
"set hidden  " Hide buffers when they are abandoned

set autoindent  " Match your current indentation level when creating a new line
"set smartindent  " Only helpful for C-like files. Disables autoindent
set hlsearch  " Highlight all search results
set shiftwidth=4  " Tab = 4 spaces
set tabstop=4  " Tab = 4 spaces
set expandtab  " Add/delete $shiftwidth-worth spaces with Tab/Bksp
set smarttab  " Add/delete $shiftwidth-worth spaces with Tab/Bksp
set laststatus=2  " Show status line as second-to-last line in window
"set statusline=%F%m%r%h%w\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]  " Status line at bottom of display
set statusline=[POS=%04l,%04v][%p%%]\ [LEN=%L]\ %F%m%r%h%w  " Status line at bottom of display
set nocompatible  " Disables strict Vi compatibility
set backspace=2  " Regular backspace key
set ignorecase  " Ignore text case when searching
set smartcase  " /cat matches  "cat",  "CAT",  "CaT". /Cat only matches  "Cat".
set linebreak  " Makes vim wrap lines on word boundaries, not in the middle of a word. 
"set paste  " Properly paste text. Overrides autoindent
set background=dark  " Change syntax color to better contrast with black background
set noincsearch  " Disable find-as-you-type searching
set mouse-=a  " Disable mouse so you can actually copy/paste with your real clipboard and not with Vim selections
syntax on  " Syntax highlighting!
set ttyfast  " Smooths out Vim scrolling
set lazyredraw  " Buffers screen updates instead of playing them constantly. Helps with draw speed with e.g. syntax highlighting
"set list  " Reveal tabs and trailing spaces  " http://www.iovene.com/61/
set listchars=tab:>-,trail:.,extends:#  " Make tabs show up as 4 spaces wide, no EOL char (set 'eol' here to show one)

" Do normal filename tab completion, not cycle-through-all completion
set wildmode=longest,list,full
set wildmenu

" Keep five lines visible above and below the cursor when scrolling
set scrolloff=5
set sidescrolloff=5

" Reload buffer when some other process changes the file on disk.
" Checks every 4 seconds.
set autoread
au CursorHold,CursorHoldI * checktime

"Enable omni-compl (Intellisense)
filetype plugin on
"set ofu=syntaxcomplete#Complete

"Automatic text substitutions
" Correct npt -> ntp
ab npt ntp
ab NPT NTP

" pydiction
filetype plugin on
let g:pydiction_location = '~/.vim/after/pydiction/complete-dict'
let g:pydiction_menu_height=15

set linebreak  " Makes vim wrap lines on word boundaries, not in the middle of a word. Note that the 'list' setting disables this - run ':se nolist' to fix that.

" C# folding : http://vim.wikia.com/wiki/Syntax-based_folding, see comment by
"au FileType cs set foldmethod=marker
"au FileType cs set foldmarker={,}
"au FileType cs set foldtext=substitute(getline(v:foldstart),'{.*','{...}',)
"au FileType cs set foldlevelstart=2

"au BufRead,BufNewFile *.fs set filetype=fs
"au BufRead,BufNewFile *.fsx set filetype=fsx

" Give PHP template files appropriate highlighting
au BufNewFile,BufRead *.tpl set filetype=php
" Go syntax highlighting
au BufRead,BufNewFile *.go set filetype=go

"filetype plugin indent on  " Enables pyflakes
set cursorline  " Horizontal line where cursor is
highlight CursorLine cterm=underline  " Solarized theme overrides the underline

set number  " Show line numbers. rnu overrides this if Vim >= 7.3 is available

if version >= 703
    set rnu  " Displayed line numbers are relative to your current position
    set undofile  " Sets a permanent undo file, so your undo history is preserved between Vim sessions
    set undodir=/tmp  " Store the undo files here
    "set cryptmethod=blowfish  " Override the weak encryption scheme Vim uses by default with a real encryption function
endif

"setlocal foldmethod=manual  " Don't use the PHP syntax folding 
"EnableFastPHPFolds  " Turn on PHP fast folds 

" Splits appear in sensible places- on the right, or below
set splitbelow
set splitright

set gdefault  " Search and replace defaults to replacing all occurrances. Use /g (global) to employ normal behavior.
set nobackup  " No files~ backup files
set directory=~/.vim/tmp  " Put temp files here instead of the same dir as the originating file

set autochdir  " Automatically change working directories to the directory of the current file

" Jumping centers the screen
nnoremap n nzz

" <space> hides search results
:noremap <silent> <Space> :silent noh<Bar>echo<CR>

" Make j/k work as expected with wrapped lines
map j gj
map k gk

" Convert all files you save to unix, regardless of what their original format was
set fileformats=unix,dos,mac
autocmd BufWritePre * set ff=unix

" Open nerdtree
map <C-n> :NERDTreeToggle<CR>
" Sudo write file with the command ":w!!"
cmap w!! w !sudo tee > /dev/null %

" Automatically install vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'fsharp/fsharpbinding', {
      \ 'for': 'fsharp',
      \ 'rtp': 'vim',
      \ 'do': 'make -C vim fsautocomplete',
      \}
"Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
Plug 'scrooloose/syntastic'
Plug 'altercation/solarized', { 'do': 'mkdir ~/.vim/colors; cp ~/.vim/plugged/solarized/vim-colors-solarized/colors/solarized.vim ~/.vim/colors' }
Plug 'tomasr/molokai', { 'do': 'mkdir ~/.vim/colors; cp ~/.vim/plugged/molokai/colors/molokai.vim ~/.vim/colors' }
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'sickill/vim-monokai'
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-misc'  " dependency of vim-session
Plug 'xolox/vim-session'
Plug 'dag/vim-fish'
Plug 'elzr/vim-json'
Plug 'hashivim/vim-terraform'
Plug 'posva/vim-vue'
Plug 'chriskempson/base16-vim'

call plug#end()

" Syntastic support for Tsuquyomi TypeScript errors
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint'] " You shouldn't use 'tsc' checker.
" Tsuquyomi tooltips
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

" Syntastic support for ESLint
let g:syntastic_javascript_checkers = ['eslint']

"" CtrlP settings
" Use ag with CtrlP file-opening plugin
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0  " ag is fast enough that CtrlP doesn't need to cache for us
endif
let g:ctrlp_switch_buffer = 'et'  " Open files in new buffers, instead of switching buffers

" TypeScript tooltips
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

set t_Co=256  " 256 color support

" colorscheme solarized

" Molokai color schemes
" colorscheme molokai
" let g:rehash256 = 1  " Molokai/Solarized 256 color support

" Base16 color schemes
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-harmonic-light


let g:session_autosave_periodic = 1  " Vim session autosave frequency
let g:session_autosave = 'no'  " Don't prompt to save session on quit

let g:fsharp_xbuild_path = "/usr/bin/xbuild"

" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set sessionoptions-=blank  " Don't save/restore Syntastic error panes when saving/restoring sessions

set foldmethod=syntax  " Attempt to fold code blocks
"autocmd Syntax * normal zR

