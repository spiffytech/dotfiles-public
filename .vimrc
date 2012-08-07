" Uncomment the following to have Vim jump to the last position when
" reopening a file
call pathogen#runtime_append_all_bundles() 
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe  "normal g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
"if has("autocmd")
"  filetype indent on
"endif

set showcmd	 " Show (partial) command in status line.
set showmatch  " Show matching brackets.
"set hidden  " Hide buffers when they are abandoned

set autoindent
"set smartindent  " Only helpful for C-like files. Disables autoindent
set hlsearch  " Highlight all search results
set shiftwidth=4  " Tab = 4 spaces
set tabstop=4  " Tab = 4 spaces
set expandtab  " Add/delete $shiftwidth-worth spaces with Tab/Bksp
set smarttab  " Add/delete $shiftwidth-worth spaces with Tab/Bksp
set laststatus=2  " Show status line as second-to-last line in window
"set statusline=%F%m%r%h%w\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]  " Status line at bottom of display
set statusline=%F%m%r%h%w\ [POS=%04l,%04v][%p%%]\ [LEN=%L]  " Status line at bottom of display
set nocompatible  " Disables strict Vi compatibility
set backspace=2  " Regular backspace key
set ignorecase  " Ignore text case when searching
set smartcase  " /cat matches  "cat",  "CAT",  "CaT". /Cat only matches  "Cat".
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

colorscheme solarized

"Enable omni-compl (Intellisense)
filetype plugin on
"set ofu=syntaxcomplete#Complete

"Automatic text substitutions
ab pymain if __name__ ==  "__main__": main()

" pydiction
filetype plugin on
let g:pydiction_location = '~/.vim/after/pydiction/complete-dict'
let g:pydiction_menu_height=15

set linebreak  " Makes vim wrap lines on word boundaries, not in the middle of a word. 

" C# folding : http://vim.wikia.com/wiki/Syntax-based_folding, see comment by
"au FileType cs set foldmethod=marker
"au FileType cs set foldmarker={,}
"au FileType cs set foldtext=substitute(getline(v:foldstart),'{.*','{...}',)
"au FileType cs set foldlevelstart=2

map <Leader>wb <Plug>VimwikiGoBackLink  " Go to the previous Vom Wiki page you had open

"filetype plugin indent on  " Enables pyflakes
set cursorline  " Horizontal line where cursor is
highlight CursorLine cterm=underline  " Solarized theme overrides the underline

set number  " Show line numbers. rnu overrides this if Vim >= 7.3 is available

if version >= 703
    set rnu  " Displayed line numbers are relative to your current position
    set undofile  " Sets a permanent undo file, so your undo history is preserved between Vim sessions
    set undodir=/tmp  " Store the undo files here
    set cryptmethod=blowfish  " Override the weak encryption scheme Vim uses by default with a real encryption function
endif

"let g:syntastic_auto_loc_list=1  " Used for the Vim xdebug extension that
"works like garbage

" when BufRead or BufNewFile event is triggered, pop off the .svn-base extension and
" manually restart filetype autocommands
"  
autocmd! BufRead    *.svn-base execute 'doautocmd filetypedetect BufRead ' . expand('%:r')
autocmd! BufNewFile *.svn-base execute 'doautocmd filetypedetect BufNewFile ' . expand('%:r')

"setlocal foldmethod=manual  " Don't use the PHP syntax folding 
"EnableFastPHPFolds  " Turn on PHP fast folds 

" Detects whether the open file is mostly tabs or spaces and changes expandtab
" accordingly. 
" http://www.outflux.net/blog/archives/2007/03/09/detecting-space-vs-tab-indentation-type-in-vim/
"function Kees_settabs()
"    if len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^\\t"')) > len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^ "'))
"        set noet ts=4 sw=4 list!
"    endif
"endfunction
"autocmd BufReadPost * call Kees_settabs()

" Hide search results when pressing 'space'. Helps after performing a
" search/replace
:noremap <silent> <Space> :silent noh<Bar>echo<CR>

set fileformats+=dos  " Should prevent Vim from adding random newlines to files. http://stackoverflow.com/questions/1050640/vim-disable-automatic-newline-at-end-of-file

" Splits appear in sensible places- on the right, or below
set splitbelow
set splitright

set gdefault  " Search and replace defaults to replacing all occurrances. Use /g to employ normal behavior.
set nobackup  " No files~ backup files

" Jumping centers the screen
nnoremap n nzz
