-- Название для ценника

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label_Load(
    IN inName         TVarChar,      -- Название объекта <Название для ценника>
    IN inName_UKR     TVarChar,      -- Название объекта <Название для ценника> укр
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);


   -- поиск в Object.ValueData
   vbId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND Object.isErased = FALSE AND TRIM (Object.ValueData) = TRIM (inName));


   -- если нашли записываем свойства
   IF COALESCE (vbId,0) <> 0 AND TRIM (inName_UKR) <> ''
   THEN
       -- сохранили свойство
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Label_UKR(), vbId, inName_UKR);

       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.06.20          *
*/

-- тест
--