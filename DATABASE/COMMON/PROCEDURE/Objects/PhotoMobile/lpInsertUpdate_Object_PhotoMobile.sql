-- Function: lpInsertUpdate_Object_PhotoMobile (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PhotoMobile (Integer, Integer, TVarChar, TBlob, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PhotoMobile(
 INOUT ioId	             Integer   ,    -- ключ объекта <> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта
    IN inPhotoData           TBlob     ,
    IN inUserId              Integer        -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
BEGIN
   
     -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PhotoMobile(), inCode, TRIM (inName));

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob( zc_ObjectBlob_PhotoMobile_Data(), ioId, inPhotoData);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PhotoMobile()
