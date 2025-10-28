---@module 'lazy'
---@type LazySpec
return {
	{
		"kristijanhusak/vim-dadbod-ui",
		opts = function()
			vim.g.dbs = {
				{
					name = "detail-concat",
					url = "jq:product-detail/concat-detail.json",
				},
			}
			vim.g.db_ui_save_location = "queries"
		end,
		optional = true,
	},
}
