-- Function: gpCheckLogin(TVarChar, TVarChar, TVarChar)

 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar);
 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar);
 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inIP           TVarChar, 
    IN inBoutiqueName TVarChar, 
    INOUT Session     TVarChar
)
RETURNS TVarChar
  AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbUnitId_user Integer;
BEGIN

     -- Определися пользователь + сессия (потом будем шифровать)
     SELECT Object_User.Id, Object_User.Id, ObjectLink_Unit.ChildObjectId
          INTO Session, vbUserId, vbUnitId_user
     FROM Object AS Object_User
          INNER JOIN ObjectString AS UserPassword
                                  ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                                 AND UserPassword.DescId    = zc_ObjectString_User_Password()
                                 AND UserPassword.ObjectId  = Object_User.Id
          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.DescId   = zc_ObjectLink_User_Unit()
                              AND ObjectLink_Unit.ObjectId = Object_User.Id
    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased  = FALSE
      AND Object_User.DescId    = zc_Object_User();


     -- нашли Магазин
     vbUnitId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inBoutiqueName)) AND Object.isErased = FALSE);
     -- Проверка - Левицкая З.
     IF COALESCE (vbUnitId, 0) = 0 AND inBoutiqueName <> '' AND vbUserId NOT IN (1017903, zc_User_Sybase(), zfCalc_UserAdmin() :: Integer)
     THEN
         RAISE EXCEPTION 'Ошибка.Выбранный магазин <%> не Найден.', inBoutiqueName;
     END IF;

    -- Проверка
    IF NOT FOUND THEN
       RAISE EXCEPTION 'Неправильный логин или пароль';
    ELSE

        -- Проверка - Подразделение НЕ может стать "пустым" - Левицкая З.
        IF vbUnitId_user > 0 AND COALESCE (vbUnitId, 0) = 0 AND vbUserId NOT IN (1017903, zc_User_Sybase(), zfCalc_UserAdmin() :: Integer)
        THEN
            RAISE EXCEPTION 'Ошибка.Логин был выполнен без указания Магазина.Необходимо запустить приложение для Магазина <%>. ', lfGet_Object_ValueData_sh (vbUnitId);
        END IF;
        --

        -- IF vbUnitId_user > 0 THEN
        -- запишем что Пользователь привязан к <Магазину> - !!!почти всегда!!! - Левицкая З.
        IF vbUserId NOT IN (1017903, zc_User_Sybase(), zfCalc_UserAdmin() :: Integer) AND vbUnitId <> 0
        THEN
            PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Unit(), vbUserId, vbUnitId);
        END IF;


        -- запишем что Пользователь "Подключился"
        PERFORM lpInsert_LoginProtocol (inUserLogin  := inUserLogin
                                      , inIP         := inIP
                                      , inUserId     := vbUserId
                                      , inIsConnect  := TRUE
                                      , inIsProcess  := FALSE
                                      , inIsExit     := FALSE
                                       );

    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.09.15                                        *
*/

-- тест
-- SELECT * FROM LoginProtocol order by 1 desc
