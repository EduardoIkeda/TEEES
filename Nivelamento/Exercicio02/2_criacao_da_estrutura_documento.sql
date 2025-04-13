-- Faz a criação da estrutura documento concanenando as informações
-- de titulo, conteudo e autor

SELECT post.title || ' ' || post.content || ' ' ||
   	 author.name || ' ' ||
   	 coalesce((string_agg(tag.name, ' ')), '') as document
FROM post
   	 JOIN author ON author.id = post.author_id JOIN posts_tags ON posts_tags.post_id = post.id
   	 JOIN tag ON tag.id = posts_tags.tag_id GROUP BY post.id, author.id;