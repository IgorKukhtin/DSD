-- Function: gpUpdate_Unit_PercentSAUA()

DROP FUNCTION IF EXISTS gpUpdate_Unit_PercentSAUA(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_PercentSAUA(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inPercentSAUA         TFloat    ,    -- Процент количество кодов в чеках для САУА
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   IF NOT EXISTS(SELECT 1 FROM ObjectLink 
                 WHERE ObjectLink.ObjectId = inId
                   AND ObjectLink.DescId = zc_ObjectLink_Unit_UnitSAUA()
                   AND COALESCE (ObjectLink.ChildObjectId, 0) <> 0)
   THEN
     inPercentSAUA  := 0;   
   END IF;
   
      -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PercentSAUA(), inId, inPercentSAUA);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.10.20                                                       *
*/

-- select * from gpUpdate_Unit_PercentSAUA(inId := 183292 , inUnitSAUA := 183291 ,  inSession := '3');