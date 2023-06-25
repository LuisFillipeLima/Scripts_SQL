CREATE FUNCTION F_RetornaIdade(
    @data_nascimento DATE,
    @data_final DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @idade INT

    SET @idade = DATEDIFF(YEAR, @data_nascimento, @data_final)

    IF (MONTH(@data_nascimento) > MONTH(@data_final) OR 
        (MONTH(@data_nascimento) = MONTH(@data_final) AND DAY(@data_nascimento) > DAY(@data_final)))
    BEGIN
        SET @idade = @idade - 1
    END

    RETURN @idade
END
