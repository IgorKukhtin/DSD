-- Function: zfGetBranchFromUnitId

DROP FUNCTION IF EXISTS zfGetBranchFromUnitId (Integer);

CREATE OR REPLACE FUNCTION zfGetBranchFromUnitId(inUnitId Integer)
RETURNS Integer AS
$BODY$
BEGIN
  CASE inUnitId 
    WHEN  719 THEN Return(8379);  -- Киев
    WHEN 1389 THEN Return(8378);  -- Донецк
    WHEN 4481 THEN Return(8377);  -- Кривой Рог
    WHEN 2994 THEN Return(8376);  -- Крым
    WHEN  999 THEN Return(18342); -- Никополь
    WHEN 1048 THEN Return(8374);  -- Одесса
    WHEN 5271 THEN Return(8381);  -- Харьков
    WHEN 2991 THEN Return(8373);  -- Херсон-Николаев
    WHEN 2780 THEN Return(8375);  -- Черкассы
  END CASE;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGetBranchFromUnitId (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM zfGetBranchFromUnitId (1)
