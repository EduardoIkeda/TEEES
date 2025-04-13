/*
-- Devido o gin ser uma abordagem de consulta estática, para multiplos idiomas
-- foi preciso usar uma coluna para armazenar o tsvector e fazer a consulta usando essa coluna
ALTER TABLE post ADD COLUMN fts_vector tsvector;

UPDATE post
SET fts_vector =
  setweight(to_tsvector(post.language::regconfig, title), 'A') ||
  setweight(to_tsvector(post.language::regconfig, content), 'B');

CREATE INDEX idx_fts_post ON post USING gin(fts_vector);
*/


-- Exemplo de consulta usando a coluna estatica
SELECT * 
FROM post 
WHERE post.fts_vector @@ to_tsquery('english', 'star');