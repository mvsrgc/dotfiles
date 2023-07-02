syntax on
let mapleader = " "
let localleader = " "

" Debugger settings
let g:termdebug_wide=1
let g:termdebugger="rust-gdb"

" Localvim
let g:localvimrc_persistent=2

set cmdheight=0
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

nmap <silent> <C-p> :Telescope projects<CR>

nmap <silent> <leader>f :Telescope find_files<CR>
nmap <silent> <leader>g :Telescope live_grep<CR>
nmap <silent> <leader>b :Telescope buffers<CR>
nmap <silent> <leader>s :Telescope coc document_symbols<CR>
nmap <silent> <leader>d :Telescope coc workspace_diagnostics<CR>
nmap <silent> gr        :Telescope coc references<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

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
nmap <leader>rn <Plug>(coc-rename)

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> K :call ShowDocumentation()<CR>

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap <C-f> and <C-b> to scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Plugins, keep it simple!
packadd termdebug

call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/telescope-coc.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'max397574/better-escape.nvim'
Plug 'terryma/vim-multiple-cursors'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'embear/vim-localvimrc'
Plug 'ahmedkhalf/project.nvim'
call plug#end()

lua << EOF
require("tokyonight").setup {
    styles = {
        comments = {italic = false},
        keywords = {italic = false}
    }
}

require("nvim-treesitter.configs").setup {
    highlight = {enable = true},
    indent = {enable = true},
    
}

require("better_escape").setup {}

require("telescope").setup({
  extensions = {
    coc = {
        prefer_locations = true,
    }
  },
})

require("telescope").load_extension('coc')
require("telescope").load_extension('projects')

require("project_nvim").setup {}
EOF

colorscheme tokyonight-storm
