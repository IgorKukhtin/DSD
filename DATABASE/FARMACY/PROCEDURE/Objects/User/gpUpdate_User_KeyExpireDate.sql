-- Function: gpUpdate_User_KeyExpireDate()

DROP FUNCTION IF EXISTS gpUpdate_User_KeyExpireDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_KeyExpireDate(
    IN inId                  Integer   ,    -- Ключ
    IN inKeyExpireDate       TDateTime ,    -- Дата истечения срока действия файлового ключа
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
    IF inId <> 0 AND inKeyExpireDate IS NOT NULL AND date_part('YEAR', inKeyExpireDate) >= 2000
    THEN
        -- сохранили свойство <Дата истечения срока действия файлового ключа>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_KeyExpireDate(), inId, inKeyExpireDate);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.03.22                                                       *
*/
