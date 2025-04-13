-- Criação da estrutura do documento, usando tsvector e suporte a idiomas
-- Alem disso, usa-se simple para usar o nome sem identificar radical para casos como nomes
SELECT to_tsvector(post.language::regconfig, post.title) ||
   	to_tsvector(post.language::regconfig, post.content) ||
   	to_tsvector('simple', author.name) ||
   	to_tsvector('simple', coalesce((string_agg(tag.name, ' ')), '')) as document
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = post.id
JOIN tag ON tag.id = posts_tags.tag_id
GROUP BY post.id, author.id;