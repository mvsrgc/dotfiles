syntax on
set mouse=a
set relativenumber
set ignorecase
set smartcase
set showmatch
set splitbelow
set splitright
set nohlsearch
set clipboard="unnamedplus"
set undofile
set pumheight=10
set timeoutlen=400
set updatetime=250
set signcolumn=yes
set smartindent
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set statusline=%F%=%m%r%h%w[%{&ff}]%y[%p%%][L\%04l/%04L,C\%04v]
set cursorline
set termguicolors
set shiftwidth=4
set nowrap


" Map leaders
let mapleader = " "
let localleader = " "

" Zig compiler settings
let g:zig_fmt_parse_errors=0

" COC extensions
let g:coc_global_extensions = ['coc-json', 'coc-rust-analyzer', 'coc-html', 'coc-css', 'coc-pairs', 'coc-html', 'coc-tsserver', 'coc-clangd', 'coc-zls']

" Plugins, keep it simple!
call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'gbprod/nord.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/telescope-coc.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nmac427/guess-indent.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'stevearc/oil.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'mrjones2014/smart-splits.nvim'
call plug#end()

" Load the plugins
lua << EOF
require("guess-indent").setup {}
require("tokyonight").setup {
    styles = {
        comments = {italic = false},
        keywords = {italic = false}
    }
}

require("nvim-treesitter.configs").setup {
    ensure_installed = {"lua", "rust", "c", "html", "css", "vim", "javascript", "python", "c"},
    highlight = {enable = true},
}

require("telescope").setup({
  extensions = {
    coc = {
        prefer_locations = true,
    },
  },
})

require("telescope").load_extension('coc')

require("toggleterm").setup {
    size = 10,
    shadding_factor = 2,
    open_mapping = [[<C-t>]],
}

require("oil").setup {}
EOF

colorscheme tokyonight-storm

" Unindent line
vnoremap <S-Tab> <gv

" Indent line
vnoremap <Tab> >gv

nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Mnemonic Keybindings
" 'f' for files, 'p' for projects, 'g' for grep, 'b' for buffers
" 's' for document symbols, 'd' for diagnostics, 'r' for references
nmap <silent> <leader>fp  :Telescope projects<CR>
nmap <silent> <leader>ff  :Telescope git_files<CR>
nmap <silent> <leader>fg  :Telescope live_grep<CR>
nmap <silent> <leader>fb  :Telescope buffers<CR>
nmap <silent> <leader>fs  :Telescope coc document_symbols<CR>
nmap <silent> <leader>fd  :Telescope coc workspace_diagnostics<CR>
nmap <silent> <leader>fr  :Telescope coc references<CR>
nmap - :Oil<CR>

" 'd' for definition, 'y' for type definition, 'i' for implementation
" 'rn' for rename, 'a' for code action
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 'z' for task run, 'x' for task build
nnoremap <leader>z :Task run<CR>
nnoremap <leader>x :Task build<CR>

" COC and Completions
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
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> K :call ShowDocumentation()<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
command! -nargs=0 Format :call CocActionAsync('format')

autocmd TermOpen term://* tnoremap <buffer> <Esc> <C-\><C-n>

" Use Taskfile to easily build and run different projects
function! RunTask(task)
  execute 'TermExec cmd="task ' . a:task . '" open=1 go_back=1'
endfunction

command! -nargs=1 Task call RunTask(<f-args>)
