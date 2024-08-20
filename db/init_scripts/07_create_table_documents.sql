
create TABLE IF NOT EXISTS core.document_types(
    id INTEGER PRIMARY KEY UNIQUE,
    name_ro VARCHAR(50) NOT NULL,
    name_en VARCHAR(50)  NULL,
    is_input BOOLEAN NOT NULL DEFAULT false,
    is_output BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS core.document_currency(
    id serial PRIMARY KEY UNIQUE,
    name  VARCHAR(10) NOT NULL,
    is_primary BOOL NOT NULL DEFAULT false
    );

CREATE TABLE IF NOT EXISTS core.document_partner_billing_details(
    id serial PRIMARY KEY UNIQUE,
    partner_id UUID NOT NULL REFERENCES core.partners(id),
    vat BOOL NOT NULL,
    registration_number VARCHAR(20) NULL,
    address TEXT NOT NULL,
    locality VARCHAR(50) NULL,
    county_code CHAR(2) NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS core.document_header(
    h_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_type INTEGER NOT NULL REFERENCES core.document_types(id),
    series VARCHAR(20) NULL,
    number VARCHAR(20) NOT NULL,
    partner_id UUID NOT NULL REFERENCES core.partners(id),
    document_partner_billing_details_id INTEGER NULL REFERENCES core.document_partner_billing_details(id),
    date date NOT NULL,
    due_date date NULL,
    inventory_id INTEGER NULL REFERENCES core.inventory(id),
    representative_id UUID NULL REFERENCES core.persons(id),
    recipe_id INTEGER NULL REFERENCES core.recipes(id),
    currency_id INTEGER NULL REFERENCES core.document_currency(id),
    notes text NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    status VARCHAR(50) NULL
    );

CREATE TABLE IF NOT EXISTS core.document_details(
    d_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    h_id UUID NOT NULL REFERENCES core.document_header(h_id),
    item_id UUID NOT NULL REFERENCES core.items(id),
    quantity double precision NOT NULL,
    price double precision NULL,
    net_value double precision NULL,
    vat_value double precision NULL,
    gros_value double precision NULL,
    d_id_source UUID NULL,
    item_type_pn VARCHAR(20) NULL
);

CREATE TABLE IF NOT EXISTS core.document_transactions(
    id serial PRIMARY KEY UNIQUE,
    name text NOT NULL,
    document_type_source_id INTEGER NOT NULL REFERENCES core.document_types(id),
    document_type_destination_id INTEGER NOT NULL REFERENCES core.document_types(id)
    );

CREATE TABLE IF NOT EXISTS core.document_connections(
    id serial PRIMARY KEY UNIQUE,
    id_transaction INTEGER NOT NULL REFERENCES core.document_transactions(id),
    h_id UUID NOT NULL REFERENCES core.document_header(h_id),
    d_id UUID NOT NULL REFERENCES core.document_details(d_id),
    h_id_source UUID NOT NULL REFERENCES core.document_header(h_id),
    d_id_source UUID NOT NULL REFERENCES core.document_details(d_id),
    item_id   UUID NOT NULL REFERENCES core.items(id),
    quantity double precision NOT NULL
    );

CREATE TYPE core.efactura_authorization_status AS ENUM('new', 'error', 'code_received', 'success');

CREATE TABLE IF NOT EXISTS core.efactura_authorizations(
    a_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES core.company(id),
    status core.efactura_authorization_status NOT NULL DEFAULT 'new',
    code CHAR(64) NULL,
    token JSON NULL,
    token_expires_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

-- efactura_xml_documents stores the generate XML documents for e-factura
-- invoices associated with core.document_header.
CREATE TABLE IF NOT EXISTS core.efactura_xml_documents(
    id BIGSERIAL PRIMARY KEY UNIQUE,
    h_id UUID NOT NULL REFERENCES core.document_header(h_id),
    invoice_xml TEXT NOT NULL,
    invoice_md5_sum CHAR(32) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

CREATE TYPE core.efactura_document_status AS ENUM('new', 'processing', 'error', 'success');

-- download_id will be set only for successfuly uploaded and processed efactura
-- documents (ie. status = 'success')
CREATE TABLE IF NOT EXISTS core.efactura_documents(
    e_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    h_id UUID NOT NULL REFERENCES core.document_header(h_id) UNIQUE,
    x_id BIGINT NOT NULL REFERENCES core.efactura_xml_documents(id),
    u_id BIGINT NULL UNIQUE, -- REFERENCES core.efactura_document_uploads(id)
    status core.efactura_document_status NOT NULL DEFAULT 'new',
    upload_index BIGINT NULL UNIQUE,
    download_id BIGINT NULL UNIQUE,
    error_message text NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );


-- for storing all uploads (eg, there was a network error during the upload or
-- there was a problem with the billing details).
CREATE TABLE IF NOT EXISTS core.efactura_document_uploads(
    id BIGSERIAL PRIMARY KEY UNIQUE,
    e_id UUID NOT NULL REFERENCES core.efactura_documents(e_id),
    x_id BIGINT NOT NULL REFERENCES core.efactura_xml_documents(id),
    status core.efactura_document_status NOT NULL DEFAULT 'new',
    upload_index BIGINT NULL UNIQUE,
    download_id BIGINT NULL UNIQUE,
    error_message text NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

CREATE TYPE core.efactura_message_state AS ENUM('processing', 'xml_errors', 'ok', 'nok');

-- core.efactura_messages stores all e-factura messages checks with state.
CREATE TABLE IF NOT EXISTS core.efactura_messages(
    id BIGSERIAL PRIMARY KEY UNIQUE,
    u_id BIGINT NOT NULL REFERENCES core.efactura_document_uploads(id),
    state core.efactura_message_state NOT NULL,
    download_id BIGINT NULL,
    error_message TEXT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
