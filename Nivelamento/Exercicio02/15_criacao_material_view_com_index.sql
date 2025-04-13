 
-- Criado uma visao materializada para simplificar a consulta de forma estática
-- Necessitando executar REFRESH MATERIALIZED VIEW search_index; em caso de atualização
-- da tabela post, author ou tag.
-- A visao materializada armazena o resultado da consulta, permitindo acesso mais rápido aos dados.
-- A consulta é feita em uma tabela temporária, que é criada a partir da junção das tabelas post, author, posts_tags e tag.

CREATE MATERIALIZED VIEW search_index AS
SELECT post.id,
   	post.title,
   	setweight(to_tsvector(post.language::regconfig, post.title), 'A') ||
   	setweight(to_tsvector(post.language::regconfig, post.content), 'B') ||
   	setweight(to_tsvector('simple', author.name), 'C') ||
   	setweight(to_tsvector('simple', coalesce(string_agg(tag.name, ' '))), 'A') as document
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = post.id
JOIN tag ON tag.id = posts_tags.tag_id
GROUP BY post.id, author.id

-- Criar o índice GIN para a visão materializada
-- o gin é um índice invertido que permite buscas mais rápidas em colunas de texto completo.
CREATE INDEX idx_fts_search ON search_index USING gin(document);

-- Exemplo de consulta para buscar posts que contenham as palavras "Endangered" e "Species"
-- A consulta utiliza o operador @@ para verificar se o documento contém a expressão de busca.
-- o uso de | (ou) e & (e) permite buscas mais flexíveis.
-- o search_index.document é o campo que contém o índice de texto completo que foi criado anteriormente.

SELECT p_search.id AS post_id, p_search.title
FROM search_index AS p_search
WHERE p_search.document @@ to_tsquery('english', 'Endangered & Species')
ORDER BY ts_rank(p_search.document, to_tsquery('english', 'Endangered & Species')) DESC;
