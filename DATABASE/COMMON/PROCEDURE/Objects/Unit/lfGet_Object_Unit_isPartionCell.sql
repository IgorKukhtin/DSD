-- Function: lfGet_Object_Unit_isPartionCell()

DROP FUNCTION IF EXISTS lfGet_Object_Unit_isPartionCell (Integer, TDatetime);
DROP FUNCTION IF EXISTS lfGet_Object_Unit_isPartionCell (TDatetime, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Unit_isPartionCell(
    IN inOperDate    TDatetime,      -- сессия пользователя
    IN inUnitId      Integer        --
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- Розподільчий комплекс
     IF inUnitId = zc_Unit_RK() AND inOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell() - INTERVAL '0 DAY'
     THEN RETURN TRUE;
     ELSE RETURN FALSE;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.24                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_Unit_isPartionCell (CURRENT_DATE + INTERVAL '1 MONTH', 8459)
