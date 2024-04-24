create TABLE IF NOT EXISTS core.recipes(
    id serial PRIMARY KEY UNIQUE,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true
    );

create TABLE IF NOT EXISTS core.recipe_items(
    id serial PRIMARY KEY UNIQUE,
    recipe_id INTEGER NOT NULL REFERENCES core.recipes(id),
    item_id  UUID NOT NULL REFERENCES core.items(id),
    quantity double precision NOT NULL,
    production_item_type VARCHAR(20) NOT NULL
    );