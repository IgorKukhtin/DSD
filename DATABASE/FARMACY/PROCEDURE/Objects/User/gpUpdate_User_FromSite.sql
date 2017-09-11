-- Function: gpUpdate_User_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_User_FromSite (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_FromSite(
    IN inId                  Integer   ,    -- Ключ
    IN inPhoto               TVarChar  ,    -- Фото
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
    IF inId <> 0
    THEN
        -- сохранили свойство <Фото>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Foto(), inId, inPhoto);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 11.09.17                                        *
*/
