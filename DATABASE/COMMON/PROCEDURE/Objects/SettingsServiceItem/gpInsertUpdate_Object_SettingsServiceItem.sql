-- Function: gpInsertUpdate_Object_SettingsServiceItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SettingsServiceItem (Integer, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SettingsServiceItem(
 INOUT ioId                       Integer   ,   	-- ключ объекта <>
    IN inSettingsServiceId        Integer   ,    -- ссылка на настройки импорта
    IN inInfoMoneyDestinationId   Integer   ,    -- ссылка на параметры
    IN inSession                  TVarChar  DEFAULT ''      -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination());
   vbUserId := lpGetUserBySession (inSession); 

   -- проверка
   vbId := (SELECT Object_SettingsServiceItem.Id
            FROM Object AS Object_SettingsServiceItem
                 INNER JOIN ObjectLink AS ObjectLink_SettingsService
                                       ON ObjectLink_SettingsService.ObjectId = Object_SettingsServiceItem.Id
                                      AND ObjectLink_SettingsService.DescId = zc_ObjectLink_SettingsServiceItem_SettingsService()
                                      AND ObjectLink_SettingsService.ChildObjectId = inSettingsServiceId
                 INNER JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                                       ON ObjectLink_InfoMoneyDestination.ObjectId = Object_SettingsServiceItem.Id
                                      AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination()
                                      AND ObjectLink_InfoMoneyDestination.ChildObjectId = inInfoMoneyDestinationId
            WHERE Object_SettingsServiceItem.DescId = zc_Object_SettingsServiceItem()
               AND Object_SettingsServiceItem.Id <> ioId
               AND ObjectLink_SettingsService.ChildObjectId = inSettingsServiceId
            );

   IF COALESCE (vbId,0) <> 0
   THEN 
       RAISE EXCEPTION 'Ошибка. Связка <%> - <%> уже существует.', lfGet_Object_ValueData_sh (inSettingsServiceId), lfGet_Object_ValueData_sh (inInfoMoneyDestinationId);
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SettingsServiceItem(), 0, '');
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SettingsServiceItem_SettingsService(), ioId, inSettingsServiceId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);

    
   -- если элемент был помечен на удаление восстанавливаем его
   IF (SELECT Object.isErased FROM Object WHERE Object.Id = ioId) = TRUE
   THEN
       PERFORM lpUpdate_Object_isErased (inObjectId:= ioId, inUserId:= vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.19         * 
*/

-- тест
--