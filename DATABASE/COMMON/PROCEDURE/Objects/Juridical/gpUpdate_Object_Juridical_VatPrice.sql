-- Function: gpUpdate_Object_Juridical_VatPrice()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_VatPrice (Integer, TDateTime, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_VatPrice(
    IN inId                  Integer   ,  -- ключ объекта <> 
    IN inVatPriceDate        TDateTime , 
    IN inIsVatPrice          Boolean   , 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_VatPrice());


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isVatPrice(), inId, inIsVatPrice);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_Juridical_VatPrice(), inId, inVatPriceDate);



   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.20         *
*/

-- тест
--