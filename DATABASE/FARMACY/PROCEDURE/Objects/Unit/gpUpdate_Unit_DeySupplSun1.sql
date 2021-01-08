-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_DeySupplSun1 (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_DeySupplSun1(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inDeySupplSun1        Integer   ,    -- Дни продаж в Дополнение СУН1
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

   -- определили признак
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_DeySupplSun1(), inId, inDeySupplSun1);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.20                                                       *
*/
--gpUpdate_Unit_DeySupplSun1()