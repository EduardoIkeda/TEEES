-- CREATE EXTENSION pg_trgm;

SELECT similarity('Something', 'something');

SELECT similarity('Something', 'samething');

SELECT similarity('Something', 'unrelated');

SELECT similarity('Something', 'everything');

SELECT similarity('Something', 'omething');