.mode line

DROP VIEW IF EXISTS authors_rus;
DROP TABLE IF EXISTS author_names;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS authors;
DROP SEQUENCE IF EXISTS author_id;

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

BEGIN TRANSACTION;
    INSERT INTO authors (is_dead) VALUES (false);
    INSERT INTO author_names VALUES (
        currval('author_id'), 'rus', ['Улицкая']
    );
    -- INSERT INTO author_names VALUES (
    --     currval('author_id'), 'rus', ['Улиц']
    -- ); -- test transaction violating pk
COMMIT;
SELECT * FROM authors_rus;

