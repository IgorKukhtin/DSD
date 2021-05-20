-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_AutoSUA(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_AutoSUA(
    IN inUnitId              Integer   ,    -- ключ объекта <Подразделение>
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

   IF COALESCE(inUnitId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   vbOperDate := CURRENT_DATE + ((8 - date_part('DOW', CURRENT_DATE)::Integer)::TVarChar||' DAY')::INTERVAL;

   IF EXISTS(SELECT 1 FROM ObjectDate
             WHERE ObjectDate.ValueData = vbOperDate
               AND ObjectDate.DescId = zc_ObjectDate_Unit_AutoSUA())
   THEN
     DELETE FROM ObjectDate
     WHERE ObjectDate.ValueData = vbOperDate
       AND ObjectDate.DescId = zc_ObjectDate_Unit_AutoSUA();
   END IF;

   -- сохранили свойство <Дату авто пересчета>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_AutoSUA(), inUnitId, vbOperDate);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.21                                                       *
*/

select * from gpUpdate_Unit_AutoSUA(inUnitId := 375627 ,  inSession := '3');