-- Criação de configuração para busca textual para o ingles
CREATE TEXT SEARCH CONFIGURATION en ( COPY = english );

ALTER TEXT SEARCH CONFIGURATION en
ALTER MAPPING FOR hword, hword_part, word
WITH unaccent, english_stem;

-- usa-se simple para autor e tags pois precisa-se da palavra inteira
-- foi adicionado unnaccent para remover acentos e caracteres especiais
-- e o uso de coalesce para evitar nulls na busca
SELECT to_tsvector(post.language::regconfig, unaccent(post.title)) ||
   	to_tsvector(post.language::regconfig, unaccent(post.content)) ||
   	to_tsvector('simple', author.name) ||
   	to_tsvector('simple', coalesce(string_agg(tag.name, ' ')))
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
JOIN tag ON author.id = post.author_id
GROUP BY post.id, author.id;