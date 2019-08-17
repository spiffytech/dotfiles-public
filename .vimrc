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

if version >= 703
    set rnu  " Displayed line numbers are relative to your current position
    set undofile  " Sets a permanent undo file, so your undo history is preserved between Vim sessions
    set undodir=/tmp  " Store the undo files here
    "set cryptmethod=blowfish  " Override the weak encryption scheme Vim uses by default with a real encryption function
else
    set number  " Show line numbers
endif

"setlocal foldmethod=manual  " Don't use the PHP syntax folding 
"EnableFastPHPFolds  " Turn on PHP fast folds 

" Don't apply folds when opening a file
set foldlevelstart=99

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

" Dependency of vim-session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'Quramy/tsuquyomi-vue'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'hashivim/vim-terraform'
Plug 'posva/vim-vue'
Plug 'chriskempson/base16-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html', 'svelte'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'evanleck/vim-svelte'

call plug#end()

" Syntastic support for Tsuquyomi TypeScript errors
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.

" Syntastic support for ESLint
let g:syntastic_javascript_checkers = ['eslint']

"" CtrlP settings
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" Use rg with CtrlP file-opening plugin
if executable('rg')
  " Use Rg over Grep
  set grepprg=rg\ --nogroup\ --nocolor

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
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif


let g:session_autosave_periodic = 1  " Vim session autosave frequency
let g:session_autosave = 'yes'  " Don't prompt to save session on quit

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

" Highlight tabs in files
set list

" Enable syntastic/eslint
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'

autocmd BufNewFile,BufRead *.vue set filetype=vue

let g:tsuquyomi_use_local_typescript = 0

" Enable RipGrep + FZF searching
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '
command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
" Fuzzy search for files tracked by git
nnoremap <C-p> :GFiles<Cr>
" Replacement for '/' command that does fuzzy searching
nmap <Leader>/ :BLines<CR>
