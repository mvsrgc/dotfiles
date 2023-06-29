syntax on
let mapleader = " "
let localleader = " "

" Debugger settings
let g:termdebug_wide=1
let g:termdebugger="rust-gdb"

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set mouse=a
set relativenumber
set ignorecase
set smartcase
set showmatch
set splitright
set nohlsearch
set clipboard="unnamedplus"
set undofile
set pumheight=10
set timeoutlen=300
set updatetime=200
set signcolumn=yes

" Debugger mappings
nnoremap <F5> :Run<CR>
nnoremap <F9> :Break<CR>
nnoremap <F10> :Over<CR>
nnoremap <F11> :Step<CR>
nnoremap <F12> :Continue<CR>
vnoremap <leader>e :Evaluate<CR>

" Change default grep program to rg
if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

set statusline=%F%=%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

" FZF Mappings
nmap <silent> <leader>f :Telescope find_files<CR>
nmap <silent> <leader>g :Telescope live_grep<CR>
nmap <silent> <leader>b :Telescope buffers<CR>

" Rust configuration
autocmd FileType rust nnoremap <F5> :setlocal makeprg=cargo\ run<CR>:make!<CR>
autocmd FileType rust nnoremap <F6> :setlocal makeprg=cargo\ build<CR>:make!<CR>

" Python configuration
autocmd FileType python nnoremap <F5> :!python3 %<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" COC Configuration
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

nnoremap <silent> K :call ShowDocumentation()<CR>

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap <C-f> and <C-b> to scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Plugins, keep it simple!
packadd termdebug

call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'windwp/nvim-autopairs'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

lua << EOF
require("nvim-autopairs").setup {}

require("tokyonight").setup {
    styles = {
        comments = {italic = false},
        keywords = {italic = false}
    }
}

require("nvim-treesitter.configs").setup {
    highlight = {enable = true}
}
EOF

colorscheme tokyonight-storm
