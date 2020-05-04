-- Function: gpUpdateObject_Partner_Personal()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_Personal (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_Personal(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPersonalId          Integer   ,    -- Сотрудник (супервайзер)
    IN inPersonalTradeId     Integer   ,    -- Сотрудник (торговый)
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Params());

   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.05.20         *
*/
