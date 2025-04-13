-- Teste da criação do vetor ts para palavras em ingles, frances e portugues.
-- Quando texto está em ingles mas o idioma requisitado é outro, ele nao reconhece bem o radical.
SELECT to_tsvector('english', 'We are running');

SELECT to_tsvector('french', 'We are running');

SELECT TO_TSVECTOR('portuguese', 'estou testando o suporte de idioma');

-- Assim, sendo necessario uma coluna para indicar o idioma
ALTER TABLE post ADD language text NOT NULL DEFAULT('english');
