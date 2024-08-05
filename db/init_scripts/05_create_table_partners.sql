create TABLE IF NOT EXISTS core.partners(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NULL,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    type VARCHAR(20) NOT NULL,
    vat_number VARCHAR(20) NULL,
    vat BOOL NOT NULL,
    registration_number VARCHAR(20) NULL,
    address TEXT NULL,
    locality VARCHAR(50) NULL,
    county_code CHAR(2) NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

