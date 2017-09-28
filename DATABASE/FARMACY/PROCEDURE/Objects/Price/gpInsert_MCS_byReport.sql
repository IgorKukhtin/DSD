-- Function: gpInsert_MCS_byReport (TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_MCS_byReport (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MCS_byReport(
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
   OUT outMCSValue                TFloat    ,    -- 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
    DECLARE vbUserId       Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF COALESCE (inMCSValue, 0 ) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Значение НТЗ должно быть больше 0';
    END IF;
    
    outMCSValue := inMCSValue;
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 27.09.17         *
*/

-- тест
-- SELECT * FROM gpInsert_MCS_byReport()
