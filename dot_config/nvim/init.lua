-- [1] TECLA LÍDER (Siempre primero que nada). Espacio es la favorita de la comunidad
vim.g.mapleader = " "

-- [2] INSTALACIÓN DE PLUGINS (Lazy.nvim). Cargar lazy.nvim si no está instalado
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Tema Nord
  { "shaunsingh/nord.nvim", lazy = false, priority = 1000, config = function()
      vim.cmd("colorscheme nord")
    end
  },

  -- Lualine (barra de estado)
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("lualine").setup()
    end
  },

  -- Telescope (fuzzy finder)
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },

  -- En la lista de plugins dentro de require("lazy").setup({ ... })
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Ayuda a recordar comandos
  { "folke/which-key.nvim", config = function() require("which-key").setup() end },

  -- Comentar líneas fácilmente
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
})

-- [3] OPCIONES GENERALES
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- [4] CONFIGURACIÓN DE PLUGINS Y KEYMAPS
-- Ponemos Telescope dentro de un pcall para que no explote si no ha cargado
local status, telescope = pcall(require, 'telescope.builtin')
if status then
    vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = "Buscar archivos" })     -- Espacio + f + f
    vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = "Buscar texto" })         -- Espacio + f + g
end

-- [5] CONFIGURACIÓN DE TREESITTER (La que dejamos afuera por el error)
vim.defer_fn(function()
    local status, ts = pcall(require, "nvim-treesitter.configs")
    if status then
        ts.setup({
            ensure_installed = { "lua", "vim", "bash" },
            highlight = { enable = true },
        })
    end
end, 100) -- Esto retrasa la carga 100ms para dar tiempo a Lazy

