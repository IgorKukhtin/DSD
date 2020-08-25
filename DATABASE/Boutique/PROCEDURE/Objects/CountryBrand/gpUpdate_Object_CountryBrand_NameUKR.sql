--

DROP FUNCTION IF EXISTS gpUpdate_Object_CountryBrand_NameUKR (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CountryBrand_NameUKR(
    IN inId           Integer,       -- Ключ объекта <Название>    
    IN inName_UKR     TVarChar,      -- Название объекта <Название> укр
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CountryBrand());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CountryBrand_UKR(), inId, inName_UKR);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.20          *
*/

-- тест
--