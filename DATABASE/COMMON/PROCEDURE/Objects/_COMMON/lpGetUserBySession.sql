-- Function: lpGetUserBySession (TVarChar)

DROP FUNCTION IF EXISTS lpGetUserBySession (TVarChar);

CREATE OR REPLACE FUNCTION lpGetUserBySession (
    IN inSession TVarChar
)
RETURNS Integer
AS
$BODY$
BEGIN
     IF inSession <> ''
     THEN -- Новая схема
          IF LENGTH (inSession) > 20
          THEN
               IF EXISTS (WITH tmp AS (SELECT OS.ObjectId AS UserId
                                            , COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) AS OperDate
                                       FROM ObjectString AS OS
                                            LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                                                                 ON ObjectDate_User_GUID.ObjectId = OS.ObjectId
                                                                AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()
                                       WHERE OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID()
                                      )
                          SELECT 1 FROM tmp WHERE tmp.OperDate < CURRENT_TIMESTAMP
                         )

                  -- !!!Временно Админу - НЕТ проверки времени сессии
                  AND NOT EXISTS (SELECT 1 FROM ObjectString AS OS WHERE OS.ObjectId = 5 AND OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID())
                  -- select lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), 5, CURRENT_TIMESTAMP + INTERVAL '12 HOUR');

               THEN
                    IF CURRENT_TIMESTAMP - INTERVAL '24 HOUR' < (SELECT COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) AS OperDate
                                                                 FROM ObjectString AS OS
                                                                      LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                                                                                           ON ObjectDate_User_GUID.ObjectId = OS.ObjectId
                                                                                          AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()
                                                                 WHERE OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID()
                                                                )
                    THEN
                        RAISE EXCEPTION 'Ошибка.Время сессии <%> истекло.Необходимо повторно зайти в программу.'
                                       , SUBSTRING
                                        (zfConvert_DateTimeShortToString ((SELECT ObjectDate_User_GUID.ValueData
                                                                           FROM ObjectString AS OS
                                                                                LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                                                                                                     ON ObjectDate_User_GUID.ObjectId = OS.ObjectId
                                                                                                    AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()
                                                                           WHERE OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID()
                                                                             AND ObjectDate_User_GUID.ValueData < CURRENT_TIMESTAMP
                                                                         ))
                                       , 10, 5)
                                        ;
                    ELSE
                        RAISE EXCEPTION 'Ошибка.Время сессии <%> истекло.Необходимо повторно зайти в программу.'
                                       , zfConvert_DateTimeShortToString ((SELECT ObjectDate_User_GUID.ValueData
                                                                           FROM ObjectString AS OS
                                                                                LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                                                                                                     ON ObjectDate_User_GUID.ObjectId = OS.ObjectId
                                                                                                    AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()
                                                                           WHERE OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID()
                                                                             AND ObjectDate_User_GUID.ValueData < CURRENT_TIMESTAMP
                                                                         ))
                                        ;
                    END IF;
 
               ELSE
                    IF EXISTS (SELECT OS.ObjectId FROM ObjectString AS OS WHERE OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID())
                    THEN
                        RETURN (SELECT OS.ObjectId FROM ObjectString AS OS WHERE OS.ValueData = inSession AND OS.DescId = zc_ObjectString_User_GUID());
                    ELSE
                        RAISE EXCEPTION 'Ошибка.Не найден Пользователь с сессией <%>.', inSession;
                    END IF;
               END IF;

          ELSE -- вернули как раньше
               RETURN to_number (inSession, '00000000000');
          END IF;

     ELSE
         RETURN 0;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.02.14                                        * check inSession <> ''
*/

-- тест
-- SELECT lpInsertUpdate_ObjectString (zc_ObjectString_User_GUID(), 5, '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
-- SELECT * FROM lpGetUserBySession (inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpGetUserBySession (inSession:= 'c83ab7a4-94d8-47d3-9ede-3f71902b4ced')
