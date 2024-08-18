-- Function: gpUpdate_Object_Partner_PersonalParam()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PersonalParam (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_PersonalParam(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPersonalId          Integer   ,    -- Сотрудник (супервайзер)
    IN inParam               Integer   ,    -- 1 Сотрудник супервайзер, 2 - Сотрудник (торговый), 3 Сотрудник мерч.
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Personal());

   
   IF inParam = 1
   THEN
       -- сохранили связь с <Сотрудник (супервайзер)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, inPersonalId);
   ELSEIF inParam = 2
   THEN
       -- сохранили связь с <Сотрудник (торговый)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, inPersonalId);
   ELSEIF inParam = 3
   THEN
       -- сохранили связь с <Сотрудник (мерчендайзер)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), inId, inPersonalId);
   END IF;    

 
   IF vbUserId = 9457
   THEN
       RAISE EXCEPTION 'Test. Ok!';
   END IF;     
     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.08.24         *
*/
