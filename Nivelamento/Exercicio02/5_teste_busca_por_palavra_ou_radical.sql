-- Esse comando retorna TRUE, porque o radical de dream é dream, 
-- então ele encontra a palavra dentro da string que foi transformada para tsvector
SELECT TO_TSVECTOR('If you can dream it, you can do it') @@ 'dream';

-- Esse comando retorna FALSE, porque o radical de impossible transformado pra tsvector
-- é imposs, logo ele nao encontra impossible.
SELECT to_tsvector('It''s kind of fun to do the impossible') @@ 'impossible';

-- Esse comando retona TRUE, porque está sendo feita a busca pelo radical de impossible
-- ao usar o comando to_tsquery, assim, ele busca imposs no vetor de ts.
SELECT to_tsvector('It''s kind of fun to do the impossible') @@ to_tsquery('impossible');
