-- Function: gpUpdate_Object_Partner_Order()


DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_GLN (Integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_GLN(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inGLNCodeJuridical    TVarChar  ,    -- Код GLN - Покупатель
    IN inGLNCodeRetail       TVarChar  ,    -- Код GLN - Получатель
    IN inGLNCodeCorporate    TVarChar  ,    -- Код GLN - Поставщик
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_GLN());

   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);

   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeJuridical(), ioId, inGLNCodeJuridical);
   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeRetail(), ioId, inGLNCodeRetail);   
   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeCorporate(), ioId, inGLNCodeCorporate);   


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.03.15         *

*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_GLN()
