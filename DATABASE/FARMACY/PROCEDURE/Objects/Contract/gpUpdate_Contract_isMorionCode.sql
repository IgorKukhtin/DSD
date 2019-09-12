-- Function: gpUpdate_Contract_isMorionCode()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isMorionCode(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isMorionCode(
    IN inId                  Integer   ,    -- ключ объекта <>
    IN inisMorionCode        Boolean   ,    -- 
   OUT outisMorionCode       Boolean   ,
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
   outisMorionCode:= NOT inisMorionCode;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_MorionCode(), inId, outisMorionCode);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.19         *
*/
--select * from gpUpdate_Contract_isMorionCode(inId := 1393106 , inisMorionCode := 'False' ,  inSession := '3');