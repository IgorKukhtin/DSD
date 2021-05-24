-- Function: gpUpdate_Object_ReplServer_Start()

DROP FUNCTION IF EXISTS gpUpdate_Object_ReplServer_Start (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReplServer_Start(
    IN inId                  Integer   , -- Ключ объекта <>
    IN inOperDate            TDateTime , -- 
    IN inIsTo                Boolean   , -- если  Да - StartTo , иначе  StartFrom
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReplServer());
     vbUserId:= lpGetUserBySession (inSession);

     IF inIsTo = TRUE 
     THEN 
         -- сохранили свойство <Дата/время начала отправки в базу-Child>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReplServer_StartTo(), inId, inOperDate);
     ELSE
         -- сохранили свойство <Дата/время начала получения из базы-Child>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReplServer_StartFrom(), inId, inOperDate);     
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.06.18         *
*/

-- тест
-- 