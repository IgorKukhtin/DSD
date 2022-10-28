-- Function: gpUpdate_User_PhotosOnSite()

DROP FUNCTION IF EXISTS gpUpdate_User_PhotosOnSite (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_PhotosOnSite(
    IN inUserId              Integer   ,    -- Ключ
    IN inisPhotosOnSite      Boolean   ,    -- Фото на сайте
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- если нашли
    IF EXISTS(SELECT 1
              FROM Object AS Object_User
              WHERE Object_User.DescId = zc_Object_User()
                AND Object_User.ID = inUserId) AND  
       NOT EXISTS(SELECT 1
                  FROM ObjectBoolean AS OB_PhotosOnSite
                  WHERE OB_PhotosOnSite.DescId = zc_ObjectBoolean_User_PhotosOnSite()
                    AND OB_PhotosOnSite.ObjectId = inUserId
                    AND COALESCE(OB_PhotosOnSite.ValueData, False) = inisPhotosOnSite)
    THEN

        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_PhotosOnSite(), inUserId, inisPhotosOnSite);

        -- Ведение протокола
        PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.22                                                       *
*/