-- Function: lpCheckOperDate_byUnit()

DROP FUNCTION IF EXISTS lpCheckOperDate_byUnit (Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpCheckOperDate_byUnit (
    IN inUnitId_by Integer  , -- Подразделение для User
    IN inOperDate  TDateTime, -- Дата Документа
    IN inUserId    Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     -- Проверка - Дата - !!!ТОЛЬКО!!! для Подразделения для User
     IF inUnitId_by > 0 AND inOperDate < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '17 HOUR')
     -- IF inUnitId_by > 0 AND inOperDate < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '1 HOUR')
     THEN
         RAISE EXCEPTION 'Ошибка.Для <%> изменение данных возможно только с <%>', lfGet_Object_ValueData_sh (inUnitId_by), zfConvert_DateToString (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '17 HOUR'));
     END IF;


END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.18                                        *
*/

-- тест
-- SELECT * FROM lpCheckOperDate_byUnit (inUnitId_by:= 1525, inOperDate:= CURRENT_DATE, inUserId:= zfCalc_UserAdmin() :: Integer)
