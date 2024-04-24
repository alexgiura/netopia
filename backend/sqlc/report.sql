-- name: GetProductionNotesReport :many
Select date::date, partner_name::text, item_name::text, item_quantity::float8, quantity1::float8, quantity2::float8, quantity3::float8, quantity4::float8, quantity5::float8, quantity6::float8  from core.get_production_note_report(sqlc.arg('start_date'), sqlc.arg('end_date'),sqlc.narg('partners')::uuid[]);

-- name: GetItemStockReport :many
Select item_code::text, item_name::text, item_um::text, item_quantity::float8  from core.get_item_stock(sqlc.arg('date'), sqlc.narg('inventory_list')::int[], sqlc.narg('item_category_list')::int[],sqlc.narg('item_list')::uuid[]);

-- name: GetTransactionAvailableItems :many
SELECT h_id::UUID, d_id::UUID, number::text, date::date, item_id::UUID, item_code::text, item_name::text,  quantity::float, um_id::INTEGER, um_name::text, vat_id::INTEGER, vat_name::text,vat_percent::float  FROM core.get_transaction_available_items(sqlc.narg('input_partners')::uuid[], sqlc.arg('input_transaction_id')::int);


