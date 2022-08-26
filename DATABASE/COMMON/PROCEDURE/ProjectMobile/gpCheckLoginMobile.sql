-- Function: gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar)

-- DROP FUNCTION IF EXISTS gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoginMobile(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inSerialNumber TVarChar,  -- Серийный номер мобильного устройства
    IN inModel        TVarChar,  -- 
    IN inVesion       TVarChar,  -- 
    IN inVesionSDK    TVarChar,  -- 
   OUT outMessage     TVarChar,  -- Сообщение об ошибке, если есть
 INOUT ioSession      TVarChar   -- 
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

--if inUserLogin ILIKE 'Админ' THEN inUserPassword:= 'qsxqsxw1'; end if;
--if inUserLogin ILIKE 'Чукрєєва М.О.' THEN inUserPassword:= 'ckv132709'; end if;

     -- Определился пользователь + сессия (потом будем шифровать)
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

    ELSIF NOT EXISTS (SELECT ObjectLink_UserRole_Role.ChildObjectId
                      FROM ObjectLink AS ObjectLink_UserRole_User
                           JOIN ObjectLink AS ObjectLink_UserRole_Role
                                           ON ObjectLink_UserRole_Role.ObjectId = ObjectLink_UserRole_User.ObjectId
                                          AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role() 
                      WHERE ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                        AND ObjectLink_UserRole_User.ChildObjectId = vbUserId
                     )
    THEN
        outMessage:= 'Пользователь добавлен некорректно, без роли, обратитесь к администратору';

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

            -- зарегистрируем его устр-во - сохранили свойство <Серийный № моб устр-ва>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_ProjectMobile(), vbUserId, inSerialNumber);
            -- сохранили свойство <Модель моб устр-ва>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_MobileModel(), vbUserId, inModel);
            -- сохранили свойство <Версия Андроид устр-ва>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_MobileVesion(), vbUserId, inVesion);
            -- сохранили свойство <Версия SDK устр-ва>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_MobileVesionSDK(), vbUserId, inVesionSDK);

            IF NOT EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile() AND ObjectBoolean.ObjectId = vbUserId)
            THEN
                -- теперь этот пользователь - это Торговый агент
                PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectMobile(), vbUserId, TRUE);
            END IF;

            -- если нет своей нумерация документов
            IF NOT EXISTS (SELECT 1 FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_User_BillNumberMobile() AND ObjectFloat.ObjectId = vbUserId AND ObjectFloat.ValueData > 0)
            THEN
                -- теперь у этого пользователя - своя нумерация документов = найдем МАКСИМУМ + 1 и умножим на 10 000
                PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_User_BillNumberMobile(), vbUserId
                                                  , (1 + COALESCE ((SELECT MAX (ObjectFloat.ValueData) / 10000 FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_User_BillNumberMobile()), 0))
                                                    * 10000
                                                   );
            END IF;

        END IF;

    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 22.09.17                                                       * проверка на наличие ролей
 17.02.17                                        *
*/

-- тест
-- SELECT * FROM LoginProtocol order by 1 desc
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= 'Молдован Е.А.', inUserPassword:= 'mld132578', inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= 'Мурзаева Е.В.', inUserPassword:= 'mrv130879', inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= 'Руденко В.В.', inUserPassword:= 'rdn132745', inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');
