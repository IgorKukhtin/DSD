-- Function: zfGetUnitFromUnitId

DROP FUNCTION IF EXISTS zfGetUnitFromUnitId (Integer);

CREATE OR REPLACE FUNCTION zfGetUnitFromUnitId(inUnitId Integer)
RETURNS Integer AS
$BODY$
BEGIN
  CASE inUnitId 
    WHEN 1389 THEN Return(8421);  -- Донецк
    WHEN  719 THEN Return(8411);  -- Киев
    WHEN 4481 THEN Return(8413);  -- Кривой Рог
    WHEN 2994 THEN Return(8419);  -- Крым
    -- WHEN  999 THEN Return(18341); -- Никополь
    WHEN  999 THEN Return(256624); -- Никополь - "Мержиєвський О.В. ФОП м. Нікополь вул. Альпова 6"
    -- WHEN 1048 THEN Return(8423);  -- Одесса
    WHEN 1048 THEN Return(346093);  -- Склад ГП ф.Одесса
    -- WHEN 1048 THEN Return(298605);  -- Одесса - "ОГОРЕНКО новый дистрибьютор"
    WHEN 5271 THEN Return(8425);  -- Харьков
    WHEN 2991 THEN Return(8417);  -- Херсон-Николаев
    WHEN 2780 THEN Return(8415);  -- Черкассы
  END CASE;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGetUnitFromUnitId (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM zfGetUnitFromUnitId (10)
