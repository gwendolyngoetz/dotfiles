return {
    {
        'Bekaboo/dropbar.nvim',
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        ---@module "dropbar"
        ---@type dropbar_configs_t
        opts = {
            sources = {
                path = {
                    max_depth = 1
                }
            },
            symbol = {
                on_click = false
            }
        }
    }
}
