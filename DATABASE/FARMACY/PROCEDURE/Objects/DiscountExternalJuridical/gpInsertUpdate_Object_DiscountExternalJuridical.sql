-- Function: gpInsertUpdate_Object_DiscountExternalJuridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalJuridical (Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternalJuridical(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inDiscountExternalId            Integer   , -- 
    IN inJuridicalId                   Integer   , -- Юридическое лицо
    IN inExternalJuridical             TVarChar  , -- Юридическое лицо проекта, идентификатор, который присваивается со стороны проекта
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternalJuridical());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountExternalJuridical());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternalJuridical(), vbCode_calc, '');

 
   -- сохранили связь с <Проекты (дисконтные карты)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalJuridical_DiscountExternal(), ioId, inDiscountExternalId);
   -- сохранили связь с <Юридическое лицо>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalJuridical_Juridical(), ioId, inJuridicalId);

   -- сохранили свойство <Юридическое лицо проекта>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalJuridical_ExternalJuridical(), ioId, inExternalJuridical);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 16.05.17                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternalJuridical (ioId:=0, inCode:=0, inDiscountExternalJuridicalKindId:=0, inSession:='2')
