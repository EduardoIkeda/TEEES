-- Criação da estrutura do documento removendo a acentuação na hora de gerar a indexação com tsvector.

SELECT to_tsvector(post.language::regconfig, unaccent(post.title)) ||
   	to_tsvector(post.language::regconfig, unaccent(post.content)) ||
   	to_tsvector('simple', unaccent(author.name)) ||
   	to_tsvector('simple', unaccent(coalesce(string_agg(tag.name, ' '))))
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = post.id
JOIN tag ON tag.id = posts_tags.tag_id
GROUP BY post.id, author.id;