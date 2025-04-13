-- Seleciona o ID do post e o titulo do post conforme a busca no resultado da query do documento
-- faz uma busca por radical usando tsquery
SELECT pid, p_title
FROM (

	-- Query da estrutura de documento feita no arquivo 3_criacao...
	SELECT post.id as pid,
         	post.title as p_title,
         	to_tsvector(post.title) ||
         	to_tsvector(post.content) ||
         	to_tsvector(author.name) ||
         	to_tsvector(coalesce(string_agg(tag.name, ' '))) as document
  	FROM post
  	JOIN author ON author.id = post.author_id
  	JOIN posts_tags ON posts_tags.post_id = post.id
  	JOIN tag ON tag.id = posts_tags.tag_id
  	GROUP BY post.id, author.id) p_search
  	
WHERE p_search.document @@ to_tsquery('Endangered & Species');