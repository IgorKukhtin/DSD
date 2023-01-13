 -- Function: gpCheckLogin(TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar);
 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
    IN inUserLogin    TVarChar,
    IN inUserPassword TVarChar,
    IN inIP           TVarChar,
 INOUT ioPhoneAuthent TVarChar,
 INOUT Session        TVarChar
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsCreate Boolean;
  DECLARE vbIsProjectAuthent Boolean;
BEGIN

     -- Определися пользователь + сессия (потом будем шифровать)
    SELECT CASE WHEN Object_User.Id = 5
                THEN FALSE
                WHEN Object_User.Id = 5 OR 1=0
                THEN CASE WHEN COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP
                            OR COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) > CURRENT_TIMESTAMP + INTERVAL '25 HOUR'
                               THEN TRUE
                               ELSE FALSE
                          END
                ELSE FALSE
           END
         , Object_User.Id
         , CASE WHEN inIP = '192.168.0.101' AND 1=0 THEN FALSE
                ELSE ObjectBoolean_ProjectAuthent.ValueData
           END
         , CASE WHEN ObjectBoolean_ProjectAuthent.ValueData = TRUE  AND inIP = '192.168.0.104'   AND 1=0 THEN '0674464560'
                WHEN ObjectBoolean_ProjectAuthent.ValueData = TRUE  AND inIP = '169.254.104.227' AND 1=0 THEN '0674464560'
                WHEN ObjectBoolean_ProjectAuthent.ValueData = TRUE  THEN TRIM (COALESCE (ObjectString_PhoneAuthent.ValueData, '')) 
                WHEN Object_User.Id = 5 AND inIP = '192.168.43.157' THEN TRIM (COALESCE (ObjectString_PhoneAuthent.ValueData, '')) 
                WHEN Object_User.Id = 5 AND 1=0 AND inIP = '62.149.5.248'   THEN TRIM (COALESCE (ObjectString_PhoneAuthent.ValueData, '')) 
                WHEN Object_User.Id = 5 AND inIP = '10.0.0.4'       THEN TRIM (COALESCE (ObjectString_PhoneAuthent.ValueData, '')) 
                ELSE '' END
           INTO vbIsCreate, vbUserId, vbIsProjectAuthent, ioPhoneAuthent
    FROM Object AS Object_User
         JOIN ObjectString AS UserPassword
                           ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                          AND UserPassword.DescId = zc_ObjectString_User_Password()
                          AND UserPassword.ObjectId = Object_User.Id
         LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                              ON ObjectDate_User_GUID.ObjectId = Object_User.Id
                             AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_ProjectAuthent
                                 ON ObjectBoolean_ProjectAuthent.ObjectId = Object_User.Id
                                AND ObjectBoolean_ProjectAuthent.DescId   = zc_ObjectBoolean_User_ProjectAuthent()
                                AND 1=0
         LEFT JOIN ObjectString AS ObjectString_PhoneAuthent
                                ON ObjectString_PhoneAuthent.ObjectId = Object_User.Id
                               AND ObjectString_PhoneAuthent.DescId   = zc_ObjectString_User_PhoneAuthent()

    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- Проверка
    IF NOT FOUND THEN
       RAISE EXCEPTION 'Неправильный логин или пароль.';
    ELSE

        -- Проверка
        IF vbIsProjectAuthent = TRUE AND ioPhoneAuthent = ''
        THEN
           RAISE EXCEPTION 'Не установлен № телефона для идентификации.';
        END IF;

        --
        IF vbUserId = 5 OR 1=0
        THEN IF vbIsCreate = TRUE
             THEN
                 --
                 Session:= gen_random_uuid();
                 -- Session:= 'c83ab7a4-94d8-47d3-9ede-3f71902b4ced';
                 --
                 IF EXISTS (SELECT 1
                            FROM ObjectLink_UserRole_View
                                 JOIN Object ON Object.Id        = ObjectLink_UserRole_View.RoleId
                                            AND (Object.ValueData ILIKE 'Кладовщ'
                                            --OR Object.ValueData ILIKE 'Торговый'
                                                )
                            WHERE ObjectLink_UserRole_View.UserId = vbUserId
                           )
                 THEN
                     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), vbUserId, CURRENT_TIMESTAMP + INTERVAL '24 HOUR');
                 ELSE
                     IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 7 AND 20
                     THEN
                         -- ?будет до 21:00
                         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), vbUserId, CURRENT_TIMESTAMP + INTERVAL '12 HOUR');
                     ELSE
                         -- добавили к текущему 12
                         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), vbUserId, CURRENT_TIMESTAMP + INTERVAL '12 HOUR');
                     END IF;
                 END IF;
                 --
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_GUID(), vbUserId, Session);

             ELSE
                 Session:= (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbUserId AND OS.DescId = zc_ObjectString_User_GUID());
             END IF;

        ELSE
            Session:= vbUserId :: TVarChar;
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
-- SELECT * FROM gpCheckLogin ('Админ', 'qsxqsxw1', '', '067-1234567', '')
