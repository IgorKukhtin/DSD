-- Function: zfCalc_PartionCell_IsClose

DROP FUNCTION IF EXISTS zfCalc_PartionCell_IsClose (TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_PartionCell_IsClose(
    IN inPartionCellName  TVarChar,
    IN inIsClose          Boolean
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (CASE WHEN inIsClose = TRUE THEN 'отбор - ' ELSE '' END
          || COALESCE (inPartionCellName, '')
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.03.24                                        *
*/

-- тест
-- SELECT * FROM zfCalc_PartionCell_IsClose ('PartionCellName', TRUE)
