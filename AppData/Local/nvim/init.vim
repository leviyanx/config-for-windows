" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named " '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Functions
" 1. Determinte environment we are runnning on(Win or Linux or Darwin) 
function! WhichEnv() abort
    if has('win64') || has('win32') || has('win16')
        return 'WINDOWS'
    else
        return toupper(substitute(system('uname'), '\n', '', ''))
    endif
endfunction
" Execuate this function only once to reduce start time
let env = WhichEnv()

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enble searching as you type, rather than waiting till you press enter.
set incsearch
" highlight matches
set hlsearch

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Map kj to ESC
" 1. press kj to exit insert mode
inoremap kj <Esc>
" 2. press kj to exit visual mode
vnoremap kj <Esc>

" Map leader to comma
let mapleader = ","
let localleader = ","

" Map Tab to 4 Space
filetype plugin indent on   " turn on filetype 'detection', 'plugin' and 'indent'
set tabstop=4               " show existing tab with 4 spaces width
set softtabstop=4           " number of spaces in tab when editing
set shiftwidth=4            " spaces in newline start
set expandtab               " On pressing tab, insert 4 spaces
" Not extend tab to 4 spaces in Makefile
autocmd FileType make setlocal noexpandtab

" Split screening
set splitbelow
set splitright
nnoremap ,x1 <C-W>o
nnoremap ,x2 :split<CR>
nnoremap ,x3 :vsplit<CR>
nnoremap ,x0 :q<CR>
" move window
nnoremap ,wh <C-W>h
nnoremap ,wl <C-W>l
nnoremap ,wj <C-W>j
nnoremap ,wk <C-W>k

" Use a line cursor within insert mode and a block cursor everything else
"
" Reference chart of values:
" Ps = 0  -> blinking block.
" Ps = 1  -> blinking block (default).
" Ps = 2  -> steady block.
" Ps = 3  -> blinking underline.
" Ps = 4  -> steady underline.
" Ps = 5  -> blinking bar (xterm).
" Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

set cursorline " highlight current line

set wildmenu    " visual autocomplete for command menu
set showmatch   " highlight matching [{()}]j

" make vim paste from (and copy to) system's clipboard
set clipboard=unnamed

" copy file name/path of current buffer in vim to system clipboard
" full path
nnoremap <leader>fn :let @*=expand("%:p")<CR>
" filename
nnoremap <leader>fp :let @*=expand("%:t")<CR>

" find (search for) selected text
vnoremap <leader>ss y/\V<C-r>=escape(@",'/\')<CR><CR>

set scrolloff=5 " lines to cursor

" open a vertical terminal in vim
nnoremap <leader>xz :vs +te<CR>

" Basic mappings
noremap ; :
nnoremap Q :q<CR>
nnoremap S :w<CR>
nnoremap <leader>wq :wq<CR>
" Open the vimrc file anytime
nnoremap <leader>ev :e $HOME/.config/nvim/init.vim<CR>
" Open the zshrc file anytime
nnoremap <leader>ez :e $HOME/.zshrc<CR>

" Specific platform setting
if env == 'DARWIN'
    " MacOS
    " Set python
    let g:python_host_skip_check = 1 " skip check to speed up loading
    let g:python_host_prog='/usr/bin/python'
    let g:python3_host_skip_check = 1 " skip check to speed up loading
    let g:python3_host_prog='/usr/bin/python3'
    " racer cmd path
    let cross_platform_racer_cmd = "/User/leviyan/.cargo/bin/racer"
 
elseif env == "WINDOWS"
    " Set python
    " racer cmd path
    " let cross_platform_racer_cmd = "/User/leviyan/.cargo/bin/racer"
elseif env == "Linux"
    let cross_platform_racer_cmd = "/User/leviyan/.cargo/bin/racer"
endif

" automatic switch between light and dark theme
function! SetBackground()
    let hour = strftime("%H")
    if 6 <= hour && hour < 18
        set background=light
        set t_Co=256
        colorscheme quietlight
    else
        set background=dark
        colorscheme everforest
    endif
endfunction
call SetBackground()
