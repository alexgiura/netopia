CREATE OR REPLACE FUNCTION core.create_department(
    dept_name VARCHAR,           -- Department name
    dept_flags INT DEFAULT 1,    -- Flags, default to 1 (active)
    parent_ids INT[] DEFAULT '{}' -- Array of parent IDs (defaults to empty array)
)
RETURNS TABLE (
    id INT,
    name VARCHAR,
    flags INT
) AS $$
DECLARE
new_id INT;
    new_name VARCHAR;
    new_flags INT;
BEGIN
    -- Insert the new department with the provided flags, defaulting to 1 if not provided
INSERT INTO core.departments (name, flags)
VALUES (dept_name, dept_flags)
    RETURNING core.departments.id, core.departments.name, core.departments.flags
INTO new_id, new_name, new_flags;

-- Insert parent-child relationships, if any parent IDs are provided
IF array_length(parent_ids, 1) IS NOT NULL THEN
        INSERT INTO core.department_relationships (parent_id, child_id)
SELECT unnest(parent_ids), new_id;
END IF;

    -- Return the inserted department's details
RETURN QUERY
SELECT new_id, new_name, new_flags;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION core.update_department(
    dept_id INT,                 -- Department ID to update
    dept_name VARCHAR,           -- New department name
    dept_flags INT,              -- New flags value
    parent_ids INT[] DEFAULT '{}' -- Array of parent IDs (optional)
)
RETURNS TABLE (
    id INT,
    name VARCHAR,
    flags INT
) AS $$
DECLARE
updated_id INT;
    updated_name VARCHAR;
    updated_flags INT;
BEGIN
    -- Update the department's name and flags
UPDATE core.departments
SET name = dept_name,
    flags = dept_flags
WHERE core.departments.id = dept_id  -- Qualify 'id' with table name to avoid ambiguity
    RETURNING core.departments.id, core.departments.name, core.departments.flags
INTO updated_id, updated_name, updated_flags;

-- Delete old relationships for this department
DELETE FROM core.department_relationships
WHERE child_id = dept_id;

-- Insert new relationships (if any parents are provided)
IF array_length(parent_ids, 1) IS NOT NULL THEN
        INSERT INTO core.department_relationships (parent_id, child_id)
SELECT unnest(parent_ids), dept_id;
END IF;

    -- Return the updated department details
RETURN QUERY
SELECT updated_id, updated_name, updated_flags;
END;
$$ LANGUAGE plpgsql;






CREATE OR REPLACE FUNCTION core.get_department_list()
RETURNS TABLE (
    id INT,
    name VARCHAR,
    flags INT
) AS $$
BEGIN

RETURN QUERY
SELECT d.id, d.name, d.flags
FROM core.departments d
ORDER BY d.id ASC;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION core.get_parent_departments(
    dept_ids INT[]
)
RETURNS TABLE (
    child_id INT,
    id INT,
    name VARCHAR,
    flags INT
) AS $$
BEGIN
RETURN QUERY
SELECT r.child_id, d.id, d.name, d.flags
FROM core.department_relationships r
         JOIN core.departments d ON r.parent_id = d.id
WHERE r.child_id = ANY(dept_ids);
END;
$$ LANGUAGE plpgsql;