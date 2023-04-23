local keymap = vim.api.nvim_set_keymap
local mStatus_ok, mason = pcall(require, 'mason')
if not mStatus_ok then
	return
end

local mlStatus_ok, mason_lsp = pcall(require, 'mason-lspconfig')
if not mlStatus_ok then
	return
end

local lStatus_ok, nvim_lsp = pcall(require, 'lspconfig')
if not lStatus_ok then
	return
end

-------------------------------------------------------------------
-- mason
-------------------------------------------------------------------
mason.setup({
	ui = {
		icons = {
			package_installed = '✓',
			package_pending = '➜',
			package_uninstalled = '✗'
		}
	}
})

-------------------------------------------------------------------
-- mason lsp
-------------------------------------------------------------------
mason_lsp.setup()
mason_lsp.setup_handlers({ function(server_name)
	local on_attach = function(client, bufnr)
		local set = vim.keymap.set
		set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
		set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
		set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
		set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
		set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
		set('n', 'gx', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
		set('n', 'g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
		set('n', 'g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
		set('n', 'J', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	end
	require('lspconfig')[server_name].setup {
		on_attach = on_attach
	}
end
})

-------------------------------------------------------------------
-- nvim-lspconfig
-------------------------------------------------------------------
local on_attach = function(client, bufnr)
	-- formatting
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("Format", { clear = true }),
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
			desc = "[lsp] format on save",
		})
	end
end

keymap('n', '<Leader>z', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })

nvim_lsp.gopls.setup { on_attach = on_attach }
nvim_lsp.solargraph.setup { on_attach = on_attach }
nvim_lsp.clangd.setup { on_attach = on_attach }
nvim_lsp.lua_ls.setup {
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
nvim_lsp.tflint.setup { on_attach = on_attach }
nvim_lsp.terraform_lsp.setup { on_attach = on_attach }
nvim_lsp.tsserver.setup {
	on_attach = on_attach,
	filetypes = {
		'javascript',
		'typescript',
		'javascriptreact',
		'typescriptreact',
		'javascript.jsx',
		'typescript.tsx',
	},
	cmd = { 'typescript-language-server', '--stdio' },
}
