-- Criação de configuração para busca textual para o frances
-- fazendo o uso do unaccent para remover acentos e caracteres especiais
CREATE TEXT SEARCH CONFIGURATION fr ( COPY = french );
ALTER TEXT SEARCH CONFIGURATION fr ALTER MAPPING
FOR hword, hword_part, word WITH unaccent, french_stem;

-- -- Exemplo de vetores de busca textual para o frances
SELECT to_tsvector('french', 'il était une fois');
SELECT to_tsvector('fr', 'il était une fois');
SELECT to_tsvector('french', unaccent('il était une fois'));
SELECT to_tsvector('fr', 'Hôtel') @@ to_tsquery('hotels') AS RESULT;        

