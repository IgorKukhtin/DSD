-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isReport(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isReport(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisReport              Boolean   ,    -- Участвует в Автоперемещении
   OUT outisReport             Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisReport:= NOT inisReport;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Report(), inId, outisReport);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 11.01.17         *

*/
--select * from gpUpdate_Contract_isReport(inId := 1393106 , inisReport := 'False' ,  inSession := '3');