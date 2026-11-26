return {
    lazy = false,
    setup = false,
    after = function()
        local kind_icons = {
            -- LLM Provider icons
            claude = '󰋦',
            openai = '󱢆',
            gemini = '',
            Groq = '',
            Openrouter = '󱂇',
            Ollama = '󰳆',
            ['Llama.cpp'] = '󰳆',
            Deepseek = ''
        }

        require("blink.cmp").setup {
            keymap = {
                preset = "none",
                ["<C-w>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },
            cmdline = {
                keymap = {
                    preset = "none",
                    ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
                    ["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
                    ["<C-w>"] = { "show", "fallback" },
                    ["<C-n>"] = { "select_next", "fallback" },
                    ["<C-p>"] = { "select_prev", "fallback" },
                    ["<Right>"] = { "select_next", "fallback" },
                    ["<Left>"] = { "select_prev", "fallback" },
                    ["<C-y>"] = { "select_and_accept", "fallback" },
                    ["<C-e>"] = { "cancel", "fallback" },
                },
                completion = {
                    menu = { auto_show = true },
                },
            },
            signature = { enabled = true },
            completion = {
                ghost_text = { enabled = false },
                menu = {
                    border = "rounded",
                    auto_show = true,
                },
                documentation = { auto_show = true },
                trigger = { prefetch_on_insert = false },
            },
            sources = {
                default = { "lsp", "path", "buffer", "snippets", "copilot" },
                providers = {
                    snippets = {
                        opts = { friendly_snippets = true },
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        async = true,
                        score_offset = 50,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust" },
            appearance = {
                nerd_font_variant = 'mono',
                kind_icons = kind_icons
            },
        }
    end,
}
