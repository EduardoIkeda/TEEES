-- Esse comando serve para pegar o documento, listar seu pid e titulo conforme a relevancia estabelecida
-- Titulo (A) > conteudo == Tag (B) > autor (C)
-- o uso de & ou | afetam o grau de relevancia pois sao as operações booleanas de AND ou OR
-- o uso de ts_rank serve para calcular a relevancia do documento, quanto maior o valor, mais relevante é o documento

SELECT pid, p_title
FROM (SELECT post.id as pid,
         	post.title as p_title,
         	setweight(to_tsvector(post.language::regconfig, post.title), 'A') ||
         	setweight(to_tsvector(post.language::regconfig, post.content), 'B') ||
         	setweight(to_tsvector('simple', author.name), 'C') ||
         	setweight(to_tsvector('simple', coalesce(string_agg(tag.name, ' '))), 'B') as document
  	FROM post
  	JOIN author ON author.id = post.author_id
  	JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
  	JOIN tag ON tag.id = posts_tags.tag_id
  	GROUP BY post.id, author.id) p_search
WHERE p_search.document @@ to_tsquery('english', 'Endangered & Species')
ORDER BY ts_rank(p_search.document, to_tsquery('english', 'Endangered & Species')) DESC;


-- Aqui sao alguns exemplos de relevancia para quando contem 1 termo, 2 termos, 1 ou outro, ambos,
SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example | document')) as relevancy;

SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example ')) as relevancy;

SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example | unkown')) as relevancy;

SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example & document')) as relevancy;

SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example & unknown')) as relevancy;
