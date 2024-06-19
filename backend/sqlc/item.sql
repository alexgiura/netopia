-- name: GetItems :many
select
    i.id as id,
    i.code as code,
    i.name as name,
    i.is_active,
    is_stock,
    um.id as um_id,
    um.name as um_name,
    um.code as um_code,
    um.is_active as um_is_active,
    vat.id as vat_id,
    vat.name as vat_name,
    vat.percent as vat_percent,
    vat.is_active as vat_is_active,
    i.id_category as category_id,
    c.name as category_name,
    c.is_active as category_is_active,
    c.generate_pn as category_generate_pn
from core.items i
         inner join core.item_um um
                    on um.id=i.id_um
         inner join core.item_vat vat
                    on vat.id=i.id_vat
         left join core.item_category c
                    on c.id=i.id_category
where (sqlc.arg(category)::integer[]) IS NULL OR cardinality(sqlc.arg(category)::integer[]) = 0 OR  i.id_category = ANY(sqlc.arg(category)::integer[]);


-- name: GetUmList :many
select id,
       name,
       code,
       is_active
from core.item_um
order by name asc;

-- name: GetVatList :many
select id,
       name,
       percent,
       exemption_reason,
       exemption_reason_code,
       is_active
from core.item_vat;

-- name: GetItemCategoryList :many
select id,
       name,
       is_active,
       generate_pn
from core.item_category;

-- name: InsertItem :one
Insert into core.items (code,name,id_um,id_vat,is_active,is_stock, id_category)
VALUES ($1,$2,$3,$4,$5,$6,$7)
    RETURNING id;

-- name: UpdateItem :exec
Update core.items
Set code=$2,
    name=$3,
    id_um=$4,
    id_vat=$5,
    is_active=$6,
    is_stock=$7,
    id_category=$8
where id=$1;

-- name: GetItemCategoryByID :one
SELECT ic.name,
       ic.is_active,
       ic.generate_pn
FROM core.item_category ic
         INNER JOIN core.items i ON i.id_category = ic.id
WHERE ic.is_active = true AND i.id = $1
    LIMIT 1;

-- name: InsertItemCategory :one
Insert into core.item_category (name,is_active,generate_pn)
VALUES ($1,$2,$3)
    RETURNING id;

-- name: UpdateItemCategory :exec
Update core.item_category
Set name=$2,
    is_active=$3,
    generate_pn=$4
where id=$1;

-- name: InsertUm :one
Insert into core.item_um (name,code,is_active)
VALUES ($1,$2,$3)
    RETURNING id, name, code, is_active;

-- name: UpdateUm :one
Update core.item_um
Set name=$2,
    code=$3,
    is_active=$4
where id=$1
    RETURNING id, name, code, is_active;
