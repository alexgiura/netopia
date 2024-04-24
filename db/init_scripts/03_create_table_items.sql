
    create TABLE IF NOT EXISTS core.item_category(
        id serial PRIMARY KEY UNIQUE,
        name VARCHAR(50) NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT true,
        generate_pn BOOLEAN NOT NULL DEFAULT false
    );
    create TABLE IF NOT EXISTS core.item_um(
        id serial PRIMARY KEY UNIQUE,
        name VARCHAR(50) NOT NULL,
        code CHAR(3) NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT true
    );
    create TABLE IF NOT EXISTS core.item_vat(
        id serial PRIMARY KEY UNIQUE,
        name VARCHAR(50) NOT NULL,
        percent double precision NOT NULL,
        exemption_reason VARCHAR(100) NULL,
        exemption_reason_code VARCHAR(50) NULL,
        is_active BOOLEAN NOT NULL DEFAULT true
    );

    create TABLE IF NOT EXISTS core.inventory(
        id serial PRIMARY KEY UNIQUE,
        name VARCHAR(50) NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT true
        );


    CREATE TABLE IF NOT EXISTS core.items(
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        code VARCHAR(50) NULL,
        name VARCHAR(50) NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT true,
        id_um  INTEGER NOT NULL REFERENCES core.item_um(id),
        is_stock BOOLEAN NOT NULL DEFAULT true,
        id_vat INTEGER NOT NULL REFERENCES core.item_vat(id),
        id_category INTEGER NULL REFERENCES core.item_category(id)
    );
