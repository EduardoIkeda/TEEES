-- Importado a extenção unaccent para remover acentos e caracteres especiais
CREATE EXTENSION unaccent;

-- Exemplo de uso do unaccent para remover acentos e caracteres especiais
SELECT unaccent('èéêë');

-- Adição de dados com acentos para teste
INSERT INTO post (id, title, content, author_id, language)
VALUES (4, 'il était une fois', 'il était une fois un hôtel ...', 2,'french')