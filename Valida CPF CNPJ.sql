CREATE FUNCTION ValidaCPFCNPJ (@input VARCHAR(20))
RETURNS VARCHAR(1)
AS
BEGIN
    DECLARE @result VARCHAR(1)
	DECLARE @sum INT = 0
    DECLARE @digit INT = 0
    
	-- Remove quaisquer caracteres não numéricos do input
    SET @input = REPLACE(@input, '.', '')
    SET @input = REPLACE(@input, '-', '')
    SET @input = REPLACE(@input, '/', '')

    -- Validação do CPF
    IF LEN(@input) = 11
    BEGIN
        

        -- Cálculo do primeiro dígito verificador
        SET @sum = (
            SELECT SUM((11 - position) * CONVERT(INT, SUBSTRING(@input, position, 1)))
            FROM (VALUES(1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11)) AS T(position)
        )
        SET @digit = (@sum * 10) % 11
        IF @digit = 10 SET @digit = 0

        IF @digit = CONVERT(INT, SUBSTRING(@input, 10, 1))
        BEGIN
            -- Cálculo do segundo dígito verificador
            SET @sum = (
                SELECT SUM((12 - position) * CONVERT(INT, SUBSTRING(@input, position, 1)))
                FROM (VALUES(1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS T(position)
            )
            SET @digit = (@sum * 10) % 11
            IF @digit = 10 SET @digit = 0

            IF @digit = CONVERT(INT, SUBSTRING(@input, 11, 1))
                SET @result = 'S'
            ELSE
                SET @result = 'N'
        END
        ELSE
            SET @result = 'N'
    END
    -- Validação do CNPJ
    ELSE IF LEN(@input) = 14
    BEGIN
        DECLARE @multipliers TABLE (position INT, value INT)

        -- Valores para cálculo do primeiro dígito verificador
        INSERT INTO @multipliers VALUES (5, 6), (4, 7), (3, 8), (2, 9), (9, 2), (8, 3), (7, 4), (6, 5), (5, 6), (4, 7), (3, 8), (2, 9)

        -- Cálculo do primeiro dígito verificador
        SET @sum = (
            SELECT SUM(value * CONVERT(INT, SUBSTRING(@input, position, 1)))
            FROM @multipliers
        )
        SET @digit = (@sum % 11)
        IF @digit < 2 SET @digit = 0
        ELSE SET @digit = 11 - @digit

        IF @digit = CONVERT(INT, SUBSTRING(@input, 13, 1))
        BEGIN
            -- Valores para cálculo do segundo dígito verificador
            DELETE FROM @multipliers
            -- Valores para cálculo do segundo dígito verificador
            INSERT INTO @multipliers VALUES (6, 5), (5, 6), (4, 7), (3, 8), (2, 9), (9, 2), (8, 3), (7, 4), (6, 5), (5, 6), (4, 7), (3, 8), (2, 9)

            -- Remove quaisquer caracteres não numéricos do input
            SET @input = REPLACE(@input, '.', '')
            SET @input = REPLACE(@input, '-', '')
            SET @input = REPLACE(@input, '/', '')

            -- Cálculo do segundo dígito verificador
            SET @sum = (
                SELECT SUM(value * CONVERT(INT, SUBSTRING(@input, position, 1)))
                FROM @multipliers
            )
            SET @digit = (@sum % 11)
            IF @digit < 2 SET @digit = 0
            ELSE SET @digit = 11 - @digit

            IF @digit = CONVERT(INT, SUBSTRING(@input, 14, 1))
                SET @result = 'S'
            ELSE
                SET @result = 'N'
        END
        ELSE
            SET @result = 'N'
    END
    ELSE
        SET @result = 'N'

    RETURN @result
END
