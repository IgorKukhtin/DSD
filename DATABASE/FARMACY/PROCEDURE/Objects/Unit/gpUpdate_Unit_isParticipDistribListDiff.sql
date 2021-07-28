-- Function: gpUpdate_Unit_isParticipDistribListDiff()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isParticipDistribListDiff(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isParticipDistribListDiff(
    IN inId                            Integer   ,    -- ключ объекта <Подразделение>
    IN inisParticipDistribListDiff     Boolean   ,    -- Участвует в распределении товара при заказе для покупателя
    IN inSession                       TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ParticipDistribListDiff(), inId, not inisParticipDistribListDiff);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.07.21                                                       *
*/