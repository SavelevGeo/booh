BEGIN TRANSACTION;
    INSERT INTO authors (is_dead) VALUES (false);
    INSERT INTO author_names VALUES (
        currval('author_id'), 'rus', ['Улицкая']
    );
    INSERT INTO author_names VALUES (
        currval('author_id'), 'rus', ['Улиц']
    ); -- test transaction violating pk
COMMIT;
SELECT * FROM authors_rus;
