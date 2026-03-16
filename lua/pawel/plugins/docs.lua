return {
    {
        "danymat/neogen",
        config = function()
            require('neogen').setup({})
            -- Keymap comment generation for Neogen
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<Leader>nc", ":lua require('neogen').generate()<CR>", opts)
        end ,
        version = "*"
    }
}


