-- Function: zfGetBranchFromUnitId

DROP FUNCTION IF EXISTS zfGetBranchFromBranchCode (Integer);

CREATE OR REPLACE FUNCTION zfGetBranchFromBranchCode(inUnitId Integer)
RETURNS Integer AS
$BODY$
BEGIN
  CASE inUnitId 
    WHEN    2 THEN Return(8379);  -- Киев
    WHEN    8 THEN Return(8378);  -- Донецк
    WHEN    7 THEN Return(8377);  -- Кривой Рог
    WHEN 2994 THEN Return(8376);  -- Крым
    WHEN  999 THEN Return(18342); -- Никополь
    WHEN    4 THEN Return(8374);  -- Одесса
    WHEN    9 THEN Return(8381);  -- Харьков
    WHEN    3 THEN Return(8373);  -- Херсон-Николаев
    WHEN    5 THEN Return(8375);  -- Черкассы
  END CASE;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGetBranchFromBranchCode (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM zfGetBranchFromUnitId (1)
