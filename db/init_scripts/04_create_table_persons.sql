create TABLE IF NOT EXISTS core.persons(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true
    );