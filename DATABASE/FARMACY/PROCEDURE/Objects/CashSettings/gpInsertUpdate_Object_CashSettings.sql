-- Function: gpInsertUpdate_Object_CashSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashSettings(TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashSettings(
    IN inShareFromPriceName      TVarChar  ,     -- Перечень фраз в названиях товаров которые можно делить с любой ценой
    IN inShareFromPriceCode      TVarChar  ,     -- Перечень кодов товаров которые можно делить с любой ценой
    IN inSession                 TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbID Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Driver());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;

   -- пытаемся найти код
   vbID := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashSettings());

   -- сохранили <Объект>
   vbID := lpInsertUpdate_Object (vbID, zc_Object_CashSettings(), 1, 'Общие настройки касс');
   
   -- сохранили Перечень фраз в названиях товаров которые можно делить с любой ценой
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceName(), vbID, inShareFromPriceName);
   
   -- сохранили Перечень кодов товаров которые можно делить с любой ценой
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceCode(), vbID, inShareFromPriceCode);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbID, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.11.19                                                       *
*/

-- тест
-- 