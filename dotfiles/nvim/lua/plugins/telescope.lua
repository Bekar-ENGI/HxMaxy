local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

-- normal file search
vim.keymap.set("n", "<leader>s", function()
    builtin.find_files({
        attach_mappings = function(_, map)
            map({ "i", "n" }, "<leader>c", actions.close)
            return true
        end,
    })
end)

-- hidden file search
vim.keymap.set("n", "<leader>S", function()
    builtin.find_files({
        hidden = true,
        attach_mappings = function(_, map)
            map({ "i", "n" }, "<leader>c", actions.close)
            return true
        end,
    })
end)
