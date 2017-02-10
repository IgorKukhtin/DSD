-- Function: gpInsertUpdate_Object_PartnerTag()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerTag(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerTag(
 INOUT ioId             Integer   ,     -- ключ объекта <Регионы(договора)> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название объекта 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PartnerTag());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PartnerTag());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PartnerTag(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PartnerTag(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartnerTag(), vbCode_calc, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PartnerTag (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PartnerTag(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')