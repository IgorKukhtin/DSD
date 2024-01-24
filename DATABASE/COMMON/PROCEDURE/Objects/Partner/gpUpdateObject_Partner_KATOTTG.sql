-- Function: gpUpdateObject_Partner_KATOTTG()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_KATOTTG (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_KATOTTG(
    IN inId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inKATOTTG             TVarChar  ,    -- КАТОТТГ
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_UnitMobile());
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);
   
   
   IF COALESCE(inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка.Нет передан ID партнера.'; 
   END IF;

   IF NOT EXISTS(SELECT 1 
                 FROM Object AS Object_Partner
                 WHERE Object_Partner.Id = inId
                   AND Object_Partner.DescId = zc_Object_Partner())
   THEN
     RAISE EXCEPTION 'Ошибка.Передан ID не партнера.'; 
   END IF;

   -- сохранили свойство с <КАТОТТГ>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_KATOTTG(), inId, inKATOTTG);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.23                                                       *
*/

-- тест
-- SELECT * FROM gpUpdateObject_Partner_KATOTTG()