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
				{
					name = "sub-product-concat",
					url = "jq:sub-product/concat-sub-product.json",
				},
				{
					name = "product-image-merge",
					url = "jq:product-image-merge.json",
				},
			}
			vim.g.db_ui_save_location = "queries"
		end,
		optional = true,
	},
}
