-- Function: gpInsertUpdate_Object_DiscountCard()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountCard (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountCard(
 INOUT ioId                  Integer   , -- ключ объекта
    IN inCode                Integer   , -- код объекта 
    IN inName                TVarChar  , -- значение
    IN inObjectId            Integer   , -- Тип почтового ящика
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountCard());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountCard());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountCard(), vbCode_calc, inName);

   -- сохранили связь с <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountCard_Object(), ioId, inObjectId);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountCard (ioId:=0, inCode:=0, inValue:='КУКУ', inObjectId:=0, inSession:='2')
