-- Function: gpSelect_Object_User_checkSMS (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User_checkSMS (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User_checkSMS(
    IN inValueSMS TVarChar,
   OUT outMessage TVarChar,
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDate_SMS TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM ObjectString AS ObjectString_User_SMS
                    WHERE ObjectString_User_SMS.ObjectId  = vbUserId
                      AND ObjectString_User_SMS.DescId    = zc_ObjectString_User_SMS()
                      AND ObjectString_User_SMS.ValueData = inValueSMS
                      AND inValueSMS <> ''
                   )
     THEN
         outMessage:= 'Ошибка.Неправильный код авторизации <'|| COALESCE (inValueSMS, '') || '>.';

     ELSE
         --
         vbDate_SMS:= (SELECT ObjectDate_User_SMS.ValueData + INTERVAL '3 MINUTES'
                       FROM ObjectDate AS ObjectDate_User_SMS
                       WHERE ObjectDate_User_SMS.ObjectId  = vbUserId
                         AND ObjectDate_User_SMS.DescId    = zc_ObjectDate_User_SMS()
                      );
         -- Проверка
         IF vbDate_SMS < CURRENT_TIMESTAMP
         THEN
             outMessage:= 'Ошибка.Срок действия для код авторизации истек в '
                      || '<' || CASE WHEN EXTRACT (HOUR   FROM vbDate_SMS) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR    FROM vbDate_SMS) :: TVarChar
                      || ':' || CASE WHEN EXTRACT (MINUTE FROM vbDate_SMS) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE  FROM vbDate_SMS) :: TVarChar
                      || ':' || CASE WHEN EXTRACT (SECOND FROM DATE_TRUNC ('SECOND', vbDate_SMS)) < 10 THEN '0' ELSE '' END || EXTRACT (SECOND FROM DATE_TRUNC ('SECOND', vbDate_SMS)) :: TVarChar

                      || '>.';
         END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.21                                        *
 */

-- тест
-- SELECT * FROM gpSelect_Object_User_checkSMS ('123', '5')
