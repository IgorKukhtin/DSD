-- Function: gpInsertUpdate_Object_Asset()

-- DROP FUNCTION gpInsertUpdate_Object_Asset();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Asset(
 INOUT ioId                  Integer   ,    -- ключ объекта < Основные средства>
    IN inCode                Integer   ,    -- Код объекта 
    IN inName                TVarChar  ,    -- Название объекта 
    IN inInvNumber           TVarChar  ,    -- Инвентарный номер
    IN inAssetGroupId        Integer   ,    -- ссылка на группу основных средств
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Asset());
   vbUserId:= inSession;

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Asset()); 

   
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Asset(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Asset(), vbCode_calc);
   -- проверка уникальности для свойства <Инвентарный номер> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Asset_InvNumber(), inInvNumber);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Asset(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_InvNumber(), ioId, inInvNumber);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_AssetGroup(), ioId, inAssetGroupId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Asset()
