INSERT INTO  core.document_types (id, name_ro,name_en, is_input, is_output)
VALUES  (1,'Factura Furnizor','Factura Furnizor', false, false),
        (2,'Factura Client', 'Factura Client', false, false),
        (3,'Aviz Furnizor', 'Aviz Furnizor', false, false),
        (4,'Aviz Client', 'Aviz Client',false, true),
        (5,'NIR', 'NIR', true, false) ,
        (6,'Bon Consum', 'Bon Consum', false, true) ,
        (7,'Nota Predare', 'Nota Predare', true, false) ,
        (8,'Raport Productie', 'Raport Productie',false, false) ;

INSERT INTO  core.document_transactions (id, name, document_type_source_id, document_type_destination_id)
VALUES  (1,'Genereaza FC din AC', 4, 2),
        (2,'Genereaza FF din AF', 3, 1),
        (3,'Genereaza BC din RP', 8, 6),
        (4,'Genereaza NP din RP', 8, 7),
        (5,'Genereaza RP din AC', 4, 8);

INSERT INTO  core.document_currency (name) VALUES ('RON');

insert into core.item_vat(name, percent, is_active) VALUES ('19%',19,true);
insert into core.item_um(id, name, code, is_active) VALUES
    (1,'buc','H87',true),
    (2,'kg','KGM',true),
    (3,'m3','MTQ',true),
    (4,'tone','TNE',true);
