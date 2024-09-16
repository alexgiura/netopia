CREATE SCHEMA IF NOT EXISTS core;

CREATE TABLE core.departments (
    id SERIAL PRIMARY KEY UNIQUE,
    name VARCHAR(50) NOT NULL,
    flags INT DEFAULT 0
);

CREATE TABLE core.department_relationships (
    parent_id INT REFERENCES core.departments(id) ON DELETE CASCADE,
    child_id INT REFERENCES core.departments(id) ON DELETE CASCADE,
    PRIMARY KEY (parent_id, child_id)
);
