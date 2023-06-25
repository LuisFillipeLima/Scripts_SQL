CREATE TABLE Templates (
  id INT PRIMARY KEY,
  NomeArquivo VARCHAR(100),
  Arquivo BLOB
);


/*O arquivo precisa estar no servidor */

INSERT INTO Templates (NomeArquivo, Arquivo)
VALUES ('arquivo1.txt', (SELECT BulkColumn FROM OPENROWSET(BULK 'C:\caminho\do\arquivo1.txt', SINGLE_BLOB) AS Arquivo));
