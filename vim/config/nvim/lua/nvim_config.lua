-- Neovim-specific configuration
-- This file is loaded after vimrc to set up Lua-only plugins

-- Check if treesitter is available (plugins may not be installed yet)
local has_treesitter, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not has_treesitter then
    vim.notify('nvim-treesitter not found. Run :PlugInstall', vim.log.levels.WARN)
    return
end

-- Treesitter configuration
treesitter_configs.setup {
    -- Languages to install
    ensure_installed = {
        'bash',
        'c',
        'css',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'python',
        'rust',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    highlight = {
        enable = true,
        -- Disable for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        additional_vim_regex_highlighting = false,
    },

    indent = {
        enable = true,
    },
}

-- Aerial configuration (code outline)
local has_aerial, aerial = pcall(require, 'aerial')
if not has_aerial then
    vim.notify('aerial.nvim not found. Run :PlugInstall', vim.log.levels.WARN)
    return
end

aerial.setup({
    -- Use treesitter as primary backend, fall back to lsp
    backends = { 'treesitter', 'lsp', 'markdown', 'man' },

    layout = {
        -- Width of the aerial window
        max_width = { 40, 0.2 },
        min_width = 20,

        -- Position aerial on the right
        default_direction = 'right',

        -- Preserve window size
        preserve_equality = false,
    },

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,

    -- Filter symbols
    filter_kind = false,

    -- Keymaps in aerial window
    keymaps = {
        ['?'] = 'actions.show_help',
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.jump',
        ['<2-LeftMouse>'] = 'actions.jump',
        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-s>'] = 'actions.jump_split',
        ['p'] = 'actions.scroll',
        ['<C-j>'] = 'actions.down_and_scroll',
        ['<C-k>'] = 'actions.up_and_scroll',
        ['{'] = 'actions.prev',
        ['}'] = 'actions.next',
        ['[['] = 'actions.prev_up',
        [']]'] = 'actions.next_up',
        ['q'] = 'actions.close',
        ['o'] = 'actions.tree_toggle',
        ['za'] = 'actions.tree_toggle',
        ['O'] = 'actions.tree_toggle_recursive',
        ['zA'] = 'actions.tree_toggle_recursive',
        ['l'] = 'actions.tree_open',
        ['zo'] = 'actions.tree_open',
        ['L'] = 'actions.tree_open_recursive',
        ['zO'] = 'actions.tree_open_recursive',
        ['h'] = 'actions.tree_close',
        ['zc'] = 'actions.tree_close',
        ['H'] = 'actions.tree_close_recursive',
        ['zC'] = 'actions.tree_close_recursive',
        ['zr'] = 'actions.tree_increase_fold_level',
        ['zR'] = 'actions.tree_open_all',
        ['zm'] = 'actions.tree_decrease_fold_level',
        ['zM'] = 'actions.tree_close_all',
        ['zx'] = 'actions.tree_sync_folds',
        ['zX'] = 'actions.tree_sync_folds',
    },

    -- Automatically open aerial when entering a buffer
    on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end,
})

-- Keymaps for aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle aerial' })
vim.keymap.set('n', '<leader>A', '<cmd>AerialNavToggle<CR>', { desc = 'Toggle aerial nav' })
