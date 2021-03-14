-- Function: gpInsertUpdate_Object_DiscountExternalSupplier()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalSupplier (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternalSupplier(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inDiscountExternalId            Integer   , -- 
    IN inJuridicalId                   Integer   , -- 	Юридические лица (поставщики)
    IN inSupplierID                    Integer   , -- ID - поставщика в проекте
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternalSupplier());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountExternalSupplier());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternalSupplier(), vbCode_calc, '');

 
   -- сохранили связь с <Проекты (дисконтные карты)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalSupplier_DiscountExternal(), ioId, inDiscountExternalId);
   -- сохранили связь с <	Юридические лица (поставщики)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalSupplier_Juridical(), ioId, inJuridicalId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountExternalSupplier_SupplierID(), ioId, inSupplierID);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.03.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternalSupplier (ioId:=0, inCode:=0, inDiscountExternalSupplierKindId:=0, inSession:='2')