-- Function: gpUpdate_Object_Retail_SummSUN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_SummSUN (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_SummSUN(
    IN inId                    Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inSummSUN               TFloat    ,     --
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_SummSUN());

   -- сохранили св-во <сумма, при которой включается СУН>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_SummSUN(), inId, inSummSUN);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.19         *
*/

-- тест
--