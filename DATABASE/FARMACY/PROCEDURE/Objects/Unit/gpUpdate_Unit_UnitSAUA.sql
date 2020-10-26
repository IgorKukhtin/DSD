-- Function: gpUpdate_Unit_UnitSAUA()

DROP FUNCTION IF EXISTS gpUpdate_Unit_UnitSAUA(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_UnitSAUA(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inUnitSAUA            Integer   ,    -- Связь с Мастер в системе автоматического управления ассортиментом САУА
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
   
   IF COALESCE(inId, 0) = COALESCE(inUnitSAUA, 0)
   THEN
     RAISE EXCEPTION 'Ошибка.Мастер на может ссылаться на самого себя';   
   END IF;
   
   IF EXISTS(SELECT 1 FROM ObjectLink 
             WHERE ObjectLink.ChildObjectId = inId
               AND ObjectLink.DescId = zc_ObjectLink_Unit_UnitSAUA())
     AND COALESCE (inUnitSAUA, 0) <> 0
   THEN
     RAISE EXCEPTION 'Ошибка.Подразделение <%> используеться как Master', (SELECT Object.ValueData FROM Object WHERE Object.Id = inId);   
   END IF;

   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitSAUA(), inId, inUnitSAUA);
   
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

-- select * from gpUpdate_Unit_UnitSAUA(inId := 183292 , inUnitSAUA := 183291 ,  inSession := '3');