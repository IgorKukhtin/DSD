-- Function: gpUpdate_Contract_isBarCodeLoad()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isBarCodeLoad(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isBarCodeLoad(
    IN inId                  Integer   ,    -- ключ объекта <>
    IN inisBarCodeLoad           Boolean   ,    -- 
   OUT outisBarCodeLoad          Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract());

   -- определили признак
   outisBarCodeLoad:= NOT inisBarCodeLoad;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_BarCodeLoad(), inId, outisBarCodeLoad);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.02.21                                                       *
*/
--select * from gpUpdate_Contract_isBarCodeLoad(inId := 1393106 , inisBarCodeLoad := 'False' ,  inSession := '3');