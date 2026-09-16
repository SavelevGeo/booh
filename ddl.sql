.mode line

DROP VIEW IF EXISTS authors_rus;
DROP VIEW IF EXISTS works_rus;
DROP VIEW IF EXISTS work_types_rus;

DROP TABLE IF EXISTS author_names;
DROP TABLE IF EXISTS work_names;
DROP TABLE IF EXISTS work_type_names;

DROP TABLE IF EXISTS languages;

DROP TABLE IF EXISTS authors;

DROP TABLE IF EXISTS work_types;
DROP TABLE IF EXISTS works;

DROP SEQUENCE IF EXISTS author_id;
DROP SEQUENCE IF EXISTS work_type_id;
DROP SEQUENCE IF EXISTS work_id;


CREATE TABLE languages AS
FROM read_json('languages.json');

ALTER TABLE languages
ADD PRIMARY KEY (iso_639_2);


CREATE SEQUENCE author_id;

CREATE TABLE authors (
    id INT PRIMARY KEY
        DEFAULT nextval('author_id'),
    birth DATE NULL,
    death DATE NULL,
    is_dead BOOL
);

CREATE TABLE author_names (
    author INT REFERENCES authors(id),
    iso_639_2 VARCHAR
        REFERENCES languages(iso_639_2),
    names VARCHAR[],
    PRIMARY KEY (author, iso_639_2)
);

CREATE VIEW authors_rus AS
SELECT array_to_string(AN_rus.names, ' ') AS name
FROM authors A
LEFT JOIN author_names AN_rus ON (
    A.id = AN_rus.author
    AND AN_rus.iso_639_2 = 'rus'
);


CREATE SEQUENCE work_type_id;

CREATE TABLE work_types (
    id INT PRIMARY KEY
        DEFAULT nextval('work_type_id')
);

CREATE TABLE work_type_names (
    work_type INT REFERENCES work_types(id),
    iso_639_2 VARCHAR
        REFERENCES languages(iso_639_2),
    names VARCHAR[],
    PRIMARY KEY (work_type, iso_639_2)
);

CREATE VIEW work_types_rus AS
SELECT array_to_string(WT_rus.names, ' ') AS name
FROM work_types WT
LEFT JOIN work_type_names WT_rus ON (
    WT.id = WT_rus.work_type
    AND WT_rus.iso_639_2 = 'rus'
);


BEGIN TRANSACTION;
    INSERT INTO authors (is_dead) VALUES (false);
    INSERT INTO author_names VALUES (
        currval('author_id'),
        'rus',
        ['Людмила', 'Улицкая']
    );
COMMIT;
SELECT * FROM authors_rus;

BEGIN TRANSACTION;
    INSERT INTO work_types DEFAULT VALUES;
    INSERT INTO work_type_names VALUES (
        currval('work_type_id'),
        'rus',
        ['Сборник', 'рассказов']
    );
COMMIT;
BEGIN TRANSACTION;
    INSERT INTO work_types DEFAULT VALUES;
    INSERT INTO work_type_names VALUES (
        currval('work_type_id'),
        'rus',
        ['Рассказ']
    );
COMMIT;
SELECT * FROM work_types_rus;
