return { 
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",

  dependencies = {
    -- Required
    "nvim-lua/plenary.nvim",
    -- Optional
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
  },

  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note", mode = "n" },
    { "<leader>op", "<cmd>ObsidianOpen<cr>", desc = "Open note in Obsidian app", mode = "n" },
    { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch", mode = "n" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes", mode = "n" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>" , desc = "Insert template from a list", mode = "n" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks", mode = "n" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "New Daily note", mode = "n" },
  },

  opts = {
    workspaces = {
      {
        name = "Development",
        path = "~/Documents/DANE/Development",
      },
    },

    templates = {
      subdir = "templates",
      created = {{date}},
      updated = "",
      tags = "",
    },

    daily_notes = {
      folder = "Review/Daily",
      date_format = "%Y-%m-%d",
      template = "1724688780-daily-template.md",
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    
    open_app_foreground = true,

    new_notes_location = "current_dir",

    ui = {
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        ["/"] = { char = "◧", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },

      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianDone = { bold = true, fg = "#7ee787" },
        ObsidianImportant = { bold = true, fg = "#f47067" },
      },
    },

    wiki_link_func = function(opts)
      if opts.id == nil then
        return string.format("[[%s]]", opts.label)
      elseif opts.label ~= opts.id then
        return string.format("[[%s|%s]]", opts.id, opts.label)
      else
        return string.format("[[%s]]", opts.id)
      end
    end,

    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { 
        id = note.id, aliases = note.aliases, tags = note.tags, 
        created = os.date("%d.%m.%Y, %X"),
        updated =  os.date("%d.%m.%Y, %X"),
      }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
            out[k] = v
        end
      end
      return out
    end,

    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
      -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({"open", url})  -- Mac OS
    end,

    mappings = {
      -- "Obsidian follow"
      ["<leader>of"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes "obsidian done"
      ["<leader>oc"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
  },

}
