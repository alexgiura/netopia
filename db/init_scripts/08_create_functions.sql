CREATE OR REPLACE FUNCTION core.get_generate_available_items(
    partnerId UUID,
    inputDate DATE,
    transactionId INTEGER
)
RETURNS TABLE (
    h_id UUID,
    d_id UUID,
    number varchar(20),
    date date,
    item_id UUID,
    item_code varchar(50),
    item_name varchar(50),
    quantity double precision,
    um_id INTEGER,
    um_name varchar(50),
    vat_id INTEGER,
    vat_name varchar(50),
    vat_percent double precision
)
AS $$
    DECLARE
documentType INTEGER;
BEGIN
SELECT document_type_source_id INTO documentType
FROM core.document_transactions
WHERE id = transactionId;
RETURN QUERY
SELECT
    dh.h_id,
    dd.d_id,
    dh.number,
    dh.date,
    dd.item_id,
    COALESCE(i.code,'') as item_code,
    i.name as item_name,
    (dd.quantity - COALESCE((
                                SELECT SUM(dc.quantity)::numeric
                                FROM core.document_connections dc
                                WHERE dc.d_id_source = dd.d_id AND dc.id_transaction =  transactionId
                            ), 0)) AS quantity,
    um.id as um_id,
    um.name as um_name,
    vat.id as vat_id,
    vat.name as vat_name,
    vat.percent as vat_percent
FROM core.document_details dd
         INNER JOIN core.document_header dh ON dh.h_id = dd.h_id
         INNER JOIN core.items i on i.id = dd.item_id
         inner join core.item_um um
                    on um.id=i.id_um
         left join core.item_vat vat
                   on vat.id=i.id_vat
WHERE
        dh.partner_id = partnerId
  AND dh.is_deleted = false
  AND dh.document_type = documentType
  AND dh.date <= inputDate
  AND (dd.quantity - COALESCE((
                                  SELECT SUM(dc.quantity)::numeric
                                  FROM core.document_connections dc
                                  WHERE dc.d_id_source = dd.d_id AND dc.id_transaction = transactionId
                              ), 0)) > 0
ORDER BY dh.date DESC;

END;
$$ LANGUAGE plpgsql;

-- Transaction available items
CREATE OR REPLACE FUNCTION core.get_transaction_available_items(
    input_partners UUID[],
    input_transaction_id INTEGER
)
RETURNS TABLE (
    h_id UUID,
    d_id UUID,
    number varchar(20),
    date date,
    item_id UUID,
    item_code varchar(50),
    item_name varchar(50),
    quantity double precision,
    um_id INTEGER,
    um_name varchar(50),
    vat_id INTEGER,
    vat_name varchar(50),
    vat_percent double precision
)
AS $$
    DECLARE
documentType INTEGER;
BEGIN
SELECT document_type_source_id INTO documentType
FROM core.document_transactions
WHERE id = input_transaction_id;
RETURN QUERY
SELECT
    dh.h_id,
    dd.d_id,
    dh.number,
    dh.date,
    dd.item_id,
    COALESCE(i.code,'') as item_code,
    i.name as item_name,
    (dd.quantity - COALESCE((
                                SELECT SUM(dc.quantity)::numeric
                                FROM core.document_connections dc
                                WHERE dc.d_id_source = dd.d_id AND dc.id_transaction =  input_transaction_id
                            ), 0)) AS quantity,
    um.id as um_id,
    um.name as um_name,
    vat.id as vat_id,
    vat.name as vat_name,
    vat.percent as vat_percent
FROM core.document_details dd
         INNER JOIN core.document_header dh ON dh.h_id = dd.h_id
         INNER JOIN core.items i on i.id = dd.item_id
         inner join core.item_um um
                    on um.id=i.id_um
         left join core.item_vat vat
                   on vat.id=i.id_vat
WHERE
    (input_partners  IS NULL OR cardinality(input_partners) =0 or  dh.partner_id = any(input_partners))
  AND dh.is_deleted = false
  AND dh.document_type = documentType

  AND (dd.quantity - COALESCE((
                                  SELECT SUM(dc.quantity)::numeric
                                  FROM core.document_connections dc
                                  WHERE dc.d_id_source = dd.d_id AND dc.id_transaction = input_transaction_id
                              ), 0)) > 0
ORDER BY dh.date DESC;

END;
$$ LANGUAGE plpgsql;


-- Insert Document Details
CREATE OR REPLACE FUNCTION core.insert_document_details(
    _h_id UUID,
    _item_id UUID,
    _quantity double precision,
    _price double precision,
    _net_value double precision,
    _vat_value double precision,
    _gros_value double precision,
    _item_type_pn text
)
RETURNS UUID
AS $$
DECLARE
returned_d_id UUID;
BEGIN
INSERT INTO core.document_details (h_id, item_id, quantity, price, net_value, vat_value, gros_value, item_type_pn)
VALUES (_h_id, _item_id, _quantity::numeric, _price::numeric, _net_value::numeric, _vat_value::numeric, _gros_value::numeric, _item_type_pn)
    RETURNING d_id INTO returned_d_id; -- Capture the returned d_id

RETURN returned_d_id;
END;
$$ LANGUAGE plpgsql;



-- Insert Document Connections
CREATE OR REPLACE FUNCTION core.insert_document_connections(
    _transaction_id int,
    _h_id UUID,
    _d_id UUID,
    _h_id_source UUID,
    _d_id_source UUID,
    _item_id UUID,
    _quantity double precision
)
RETURNS void
AS $$
DECLARE
BEGIN
insert into core.document_connections (id_transaction, h_id, d_id, h_id_source, d_id_source, item_id, quantity)
VALUES ( _transaction_id, _h_id, _d_id,_h_id_source,_d_id_source,_item_id, _quantity::numeric);
END;
$$ LANGUAGE plpgsql;



-- Reports
-- Sales chart
CREATE OR REPLACE FUNCTION core.get_sales_actual_vs_last()
RETURNS TABLE (
    month TEXT,
    amount_this_year float,
    amount_last_year float
) AS $$
BEGIN
RETURN QUERY
    WITH months AS (
        SELECT generate_series(1, 12) AS month
    ), sales AS (
        SELECT
            EXTRACT(YEAR FROM dh.date) AS sale_year,
            EXTRACT(MONTH FROM dh.date) AS sale_month,
            SUM(dd.net_value) AS total_amount
        FROM
            core.document_details dd
        INNER JOIN core.document_header dh ON dh.h_id = dd.h_id
        WHERE
            dh.document_type = 2
            AND dh.date >= (DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year')
            AND dh.date < (DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 year')
        GROUP BY sale_year, sale_month
    )
SELECT
    to_char(DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 month' * (months.month - 1), 'Mon') AS month,
        COALESCE(s2.total_amount, 0) AS amount_this_year,
        COALESCE(s1.total_amount, 0) AS amount_last_year
FROM
    months
    LEFT JOIN sales s1 ON s1.sale_month = months.month AND s1.sale_year = EXTRACT(YEAR FROM CURRENT_DATE) - 1
    LEFT JOIN sales s2 ON s2.sale_month = months.month AND s2.sale_year = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY
    months.month;
END;
$$ LANGUAGE plpgsql;



-- Production note report
CREATE OR REPLACE FUNCTION core.get_production_note_report(
    input_from_date DATE,
    input_to_date DATE,
    input_partners UUID[]
)
RETURNS TABLE (
    date date,
    partner_name text,
    item_name text,
    item_quantity double precision,
    quantity1 double precision,
    quantity2 double precision,
    quantity3 double precision,
    quantity4 double precision,
    quantity5 double precision,
    quantity6 double precision

) AS $$
BEGIN
RETURN query (
    SELECT
        sub.date,
        sub.partner_name::text,
        sub.final_product_name::text as item0_name,
        SUM(CASE WHEN sub.item_type_pn = 'finalProduct' THEN sub.quantity ELSE 0 END) AS item0_quantity,
        COALESCE(SUM(CASE WHEN sub.item_name = 'Sort 0-4' THEN quantity ELSE 0 END), 0) AS item1_quantity,
        COALESCE(SUM(CASE WHEN sub.item_name = 'Sort 4-8' THEN quantity ELSE 0 END), 0) AS item2_quantity,
        COALESCE(SUM(CASE WHEN sub.item_name = 'Sort 8-16' THEN quantity ELSE 0 END), 0) AS item3_quantity,
        COALESCE(SUM(CASE WHEN sub.item_name = 'Sort 16-32' THEN quantity ELSE 0 END), 0) AS item4_quantity,
        COALESCE(SUM(CASE WHEN sub.item_name = 'Ciment' THEN quantity ELSE 0 END), 0) AS item5_quantity,
        COALESCE(SUM(CASE WHEN sub.item_name = 'Aditiv' THEN quantity ELSE 0 END), 0) AS item6_quantity
    FROM (
        SELECT
            h.date,
            p.name AS partner_name,
            (SELECT i2.name FROM core.items i2
             WHERE i2.id IN (SELECT d2.item_id FROM core.document_details d2 WHERE d2.h_id = h.h_id AND d2.item_type_pn = 'finalProduct')
             LIMIT 1) AS final_product_name,
            d.item_type_pn,
            i.name AS item_name,
            d.quantity
        FROM core.document_details d
        INNER JOIN core.document_header h ON d.h_id = h.h_id
        INNER JOIN core.partners p ON p.id = h.partner_id
        INNER JOIN core.items i ON i.id = d.item_id
        WHERE h.document_type = 8
          AND h.is_deleted=false
          AND h.date >= input_from_date
          AND h.date <= input_to_date
          AND (input_partners IS NULL OR cardinality(input_partners) = 0 OR  h.partner_id  = ANY(input_partners))
--           AND (h.partner_id = input_partner_id OR input_partner_id IS NULL)
    ) sub
    GROUP BY sub.date, sub.partner_name, sub.final_product_name);
END;
$$
LANGUAGE plpgsql;

-- Item stock report
CREATE FUNCTION core.get_item_stock(input_date date, input_inventory_list int[], input_item_category_list int[], input_item_list uuid[])
    returns TABLE(item_code text, item_name text, item_um text, item_quantity double precision)
    as
$$
BEGIN
RETURN QUERY
SELECT
    COALESCE(i.code::text,'') as item_code,
    i.name::text as item_name,
        um.name::text as item_um,
        (SUM(CASE WHEN dt.is_input=true THEN dd.quantity::numeric ELSE 0 END) -
         SUM(CASE WHEN  dt.is_output=true THEN dd.quantity::numeric ELSE 0 END))::double precision AS stock
from core.items i

    left join core.document_details dd
on dd.item_id=i.id
    left join core.document_header dh on dh.h_id=dd.h_id AND dh.date<=input_date
    left join core.document_types dt on dt.id=dh.document_type
    left join core.item_um um on um.id=i.id_um

where i.is_active=true
  AND i.is_stock=true
  AND dh.is_deleted=false

  AND (cardinality(input_inventory_list)=0 OR input_inventory_list IS NULL OR  dh.inventory_id =ANY(input_inventory_list))
  AND (cardinality(input_item_category_list)=0 OR input_item_category_list IS NULL OR  i.id_category =ANY(input_item_category_list))
  AND (cardinality(input_item_list)=0 OR input_item_list IS NULL OR  i.id =ANY(input_item_list))

GROUP BY
    i.id, um.id;

END;
$$
LANGUAGE plpgsql;












