-- Function: gpUpdate_Juridical_isLongUKTZED()

DROP FUNCTION IF EXISTS gpUpdate_Juridical_isLongUKTZED(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Juridical_isLongUKTZED(
    IN inId                  Integer   ,    -- ключ объекта <юр.лицо>
    IN inisLongUKTZED        Boolean   ,    -- 10-ти значный код УКТ ЗЕД
   OUT outisLongUKTZED       Boolean   ,
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
   outisLongUKTZED:= NOT inisLongUKTZED;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Juridical_isLongUKTZED(), inId, outisLongUKTZED);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 13.01.17         *

*/
--select * from gpUpdate_Juridical_isLongUKTZED(inId := 1393106 , inisLongUKTZED := 'False' ,  inSession := '3');