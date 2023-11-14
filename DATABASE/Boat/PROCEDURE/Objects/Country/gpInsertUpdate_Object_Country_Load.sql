--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Country_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Country_Load(
    IN inCountryName         TVarChar,      -- Название счет
    IN inShortName           TVarChar,      -- Название Назначения
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbCountryId     Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inShortName,'') <> ''
   THEN
       -- поиск 
       vbCountryId := (SELECT ObjectString.ObjectId
                       FROM ObjectString
                       WHERE ObjectString.DescId = zc_ObjectString_Country_ShortName()
                         AND TRIM (ObjectString.ValueData) = TRIM (inShortName)
                       LIMIT 1
                       );

       -- Eсли не нашли записываем
       IF COALESCE (vbCountryId,0) = 0
       THEN
           -- записываем новый элемент
           PERFORM gpInsertUpdate_Object_Country (ioId          := 0
                                                , ioCode        := 0
                                                , inName        := TRIM (inCountryName)
                                                , inShortName   := TRIM (inShortName)
                                                , inSession     := inSession
                                                 );
       ELSE 
            --обновляем и если удален восстаноавливаем
            UPDATE Object 
            SET ValueData = TRIM (inCountryName)
              , isErased  = FALSE
            WHERE Object.Id = vbCountryId
              AND Object.DescId = zc_Object_Country();
       END IF;
       
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.23          *
*/

-- тест
--