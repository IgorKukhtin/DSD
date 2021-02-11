-- Торговая марка

DROP FUNCTION IF EXISTS gpUpdate_Object_TaxKind (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_TaxKind(
    IN inId              Integer,       -- ключ объекта <>
    IN inName            TVarChar,      -- главное Название 
    IN inValue           TFloat  ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TaxKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (inId, zc_Object_TaxKind(), inName, vbUserId);

   vbCode := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = inId AND Object.DescId = zc_Object_TaxKind());
   
   -- сохранили
   PERFORM lpInsertUpdate_Object(inId, zc_Object_TaxKind(), vbCode, inName);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TaxKind_Value(), inId, inValue);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.21         *
*/

-- тест
--