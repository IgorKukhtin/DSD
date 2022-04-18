-- Function: gpSelect_ShowPUSH_ChechSetErased(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_NewUser(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_NewUser(
    IN inUserID       integer,          -- Пользователь
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

  outShowMessage := False;
  outText := '';

  IF COALESCE (inUserID, 0) <> 0
  THEN
    outShowMessage := True;
    outPUSHType := zc_TypePUSH_Information();
    
    SELECT 'Информация для нового сотрудника:'||CHR(13)||CHR(13)||
           'Логин  - '||Object_User.ValueData||CHR(13)||CHR(13)||
           'Пароль - '||ObjectString_UserPassword.ValueData
    INTO outText
    FROM Object AS Object_User
         LEFT JOIN ObjectString AS ObjectString_UserPassword 
                ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password() 
               AND ObjectString_UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.Id = inUserID;    
  END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.04.23                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_NewUser(3, '3')