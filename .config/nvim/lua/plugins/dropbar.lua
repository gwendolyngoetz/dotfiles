return {
    {
        'Bekaboo/dropbar.nvim',
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        config = function()
            require('dropbar').setup({
                sources = {
                    path = {
                        max_depth = 1
                    }
                },
                symbol = {
                    on_click = false
                }
            })
        end
    }
}
