return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup({
            auto_session_supress_dirs = {"~/"},
            session_lens = {
                buftypes_to_ignore = {},
                load_on_setup = true, 
                theme_config = {border = true},
                previewer = false,
            },
        })
    end,
}
