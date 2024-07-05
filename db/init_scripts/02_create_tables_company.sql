CREATE TABLE IF NOT EXISTS core.company(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    vat_number VARCHAR(20) NOT NULL UNIQUE,
    vat BOOL NOT NULL,
    registration_number VARCHAR(20) NULL,
    address TEXT NOT NULL,
    locality VARCHAR(50) NULL,
    county_code CHAR(2) NULL,
    email TEXT NULL,
    bank_name TEXT NULL,
    bank_account TEXT NULL,
    frontend_url VARCHAR(200) NULL
    );
