-- name: GetRecipes :many
SELECT
    id,
    name,
    is_active
from core.recipes;

-- name: GetRecipeById :one
SELECT
    id,
    name,
    is_active
from core.recipes
where id=$1;

-- name: GetRecipeItemsById :many
select
    ri.item_id as item_id,
    i.code as item_code,
    i.name as item_name,
    quantity,
    um.id as um_id,
    um.name as um_name,
    um.code AS um_code,
    ri.production_item_type as item_type_pn

from core.recipe_items ri
         inner join core.items i
                    on i.id=ri.item_id
         inner join core.item_um um
                    on um.id=i.id_um
where recipe_id=$1;

-- name: GetRecipeItemsByDocumentIds :many
SELECT
    ri.d_id as d_id,
    recipe_id as recipe_id,
    ri.item_id as item_id,
    i.code as item_code,
    i.name as item_name,
    quantity,
    um.id as um_id,
    um.name as um_name,
    um.code AS um_code,
    vat.id as vat_id,
    vat.name as vat_name,
    vat.percent as vat_percent,
    vat.exemption_reason AS vat_exemption_reason,
    vat.exemption_reason_code AS vat_exemption_reason_code,
    ri.production_item_type as item_type_pn
from core.recipe_items ri
         inner join core.items i
                    on i.id=ri.item_id
         inner join core.item_um um
                    on um.id=i.id_um
         inner join core.item_vat vat
                    on vat.id=i.id_vat

WHERE
        recipe_id = ANY($1::int[]);


-- name: GetRecipeByItemId :many
SELECT
    r.id,
    r.name,
    r.is_active
from core.recipes r
inner JOIN core.items i ON r.name = i.name
WHERE r.is_active=true and i.id = $1;


-- name: SaveRecipe :one
insert into core.recipes(name, is_active) VALUES ($1,$2)
    RETURNING id;

-- name: SaveRecipeItems :one
Insert into core.recipe_items(recipe_id, item_id, quantity, production_item_type)
VALUES  ($1,$2,$3,$4)
    RETURNING d_id;


-- name: UpdateRecipe :exec
update core.recipes
SET name=$2, is_active=$3
where id=$1;

-- name: DeleteRecipeItems :exec
delete from core.recipe_items
where recipe_id=$1;
