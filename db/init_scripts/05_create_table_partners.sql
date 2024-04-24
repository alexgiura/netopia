create TABLE IF NOT EXISTS core.partners(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NULL,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    type VARCHAR(20) NOT NULL,
    tax_id VARCHAR(20) NULL,
    company_number VARCHAR(20) NULL,
    personal_id VARCHAR(20) NULL
    );
