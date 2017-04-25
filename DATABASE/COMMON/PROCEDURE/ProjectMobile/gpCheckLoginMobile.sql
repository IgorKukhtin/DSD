-- Function: gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoginMobile(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inSerialNumber TVarChar,  -- Серийный номер мобильного устройства
   OUT outMessage     TVarChar,  -- Сообщение об ошибке, если есть
 INOUT ioSession      TVarChar   -- 
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- Определися пользователь + сессия (потом будем шифровать)
     SELECT Object_User.Id, Object_User.Id
          INTO ioSession, vbUserId
     FROM Object AS Object_User
          JOIN ObjectString AS UserPassword
                            ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                           AND UserPassword.DescId = zc_ObjectString_User_Password()
                           AND UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- Проверка
    IF NOT FOUND
    THEN
       outMessage:= 'Неправильный логин или пароль';
       -- RAISE EXCEPTION 'Неправильный логин или пароль';
    ELSE
        -- запишем что Пользователь "Подключился"
        PERFORM lpInsert_LoginProtocol (inUserLogin  := inUserLogin
                                      , inIP         := inSerialNumber
                                      , inUserId     := vbUserId
                                      , inIsConnect  := TRUE
                                      , inIsProcess  := FALSE
                                      , inIsExit     := FALSE
                                       );

        
        IF vbUserId <> zfCalc_UserAdmin() :: Integer
        THEN
            -- проверим его устр-во
            -- не забыть написать код

            -- зарегистрируем его устр-во - сохранили свойство <Серийный № моб устр-ва >
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_ProjectMobile(), vbUserId, inSerialNumber);

            IF NOT EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile() AND ObjectBoolean.ObjectId = vbUserId)
            THEN
                -- теперь этот пользователь - это Торговый агент
                PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectMobile(), vbUserId, TRUE);
            END IF;

        END IF;

    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.17                                        *
*/

-- тест
-- SELECT * FROM LoginProtocol order by 1 desc
