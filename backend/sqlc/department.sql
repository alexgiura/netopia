
-- name: GetDepartmentList :many
Select id::int, name::text, flags::int  from core.get_department_list();

-- name: InsertDepartment :one
SELECT id::int, name::text, flags::int FROM core.create_department(sqlc.arg('name')::text, sqlc.narg('flags')::int,sqlc.narg('parent_ids')::int[]);

-- name: UpdateDepartment :one
SELECT id::int, name::text, flags::int FROM core.update_department(sqlc.arg('id'), sqlc.narg('name')::text, sqlc.narg('flags')::int, sqlc.narg('parent_ids')::int[]);


-- name: GetParentDepartments :many
SELECT child_id::int,id::int, name::text, flags::int FROM core.get_parent_departments(sqlc.narg('department_ids')::int[]);