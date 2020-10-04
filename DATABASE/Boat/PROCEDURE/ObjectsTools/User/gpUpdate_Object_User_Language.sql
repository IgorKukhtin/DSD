-- Function: gpUpdate_Object_User_Language()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_Language (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_User_Language(
    IN inLanguageCode Integer ,      -- 
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbLanguageId Integer;  
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);
      
      -- Проверка
      IF COALESCE (vbUserId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Не найден пользователь для сессии = <%>', inSession;
      END IF;

      -- поиск
      vbLanguageId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.ObjectCode = inLanguageCode);
      -- Проверка
      IF COALESCE (vbLanguageId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Не найден язык перевода для кода = <%>', inLanguageCode;
      END IF;


      -- сохранили свойство  <физ. лицо>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Language(), vbUserId, vbLanguageId);

      -- Ведение протокола
       PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_User_Language (2, zfCalc_UserAdmin())
