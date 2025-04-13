-- Visao materializada para consulta de palavras semelhantes
-- Usa simple fazer a tabela de consulta completa por estar em multiplos idiomas
CREATE MATERIALIZED VIEW unique_lexeme AS
SELECT word FROM TS_STAT(
'SELECT 	to_tsvector(''simple'', post.title) ||
			to_tsvector(''simple'', post.content) ||
			to_tsvector(''simple'', author.name) ||
			to_tsvector(''simple'', coalesce(string_agg(tag.name, '' '')))
FROM public.post
JOIN public.author ON author.id = post.author_id
JOIN public.posts_tags ON posts_tags.post_id = post.id
JOIN public.tag ON tag.id = posts_tags.tag_id
GROUP BY post.id, author.id');

-- Criar o índice GIN para a visão materializada
CREATE INDEX words_idx ON unique_lexeme USING gin(word gin_trgm_ops);
REFRESH MATERIALIZED VIEW unique_lexeme;

-- Exemplo de consulta para buscar palavras semelhantes
-- 0.5 é o limite de similaridade, ou seja, palavras com mais de 50% de similaridade
-- quanto mais próximo de 1, mais semelhante é a palavra só que pode não retornar nada
-- quanto mais próximo de 0, menos semelhante é a palavra só que pode retornar muitas palavras
-- o limit 1 é para retornar apenas uma palavra semelhante

SELECT word
FROM unique_lexeme
WHERE similarity(word, 'samething') > 0.5
ORDER BY word <-> 'samething'
LIMIT 1;