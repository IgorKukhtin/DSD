-- Function: gpGet_User_IsAdmin (TVarChar)

DROP FUNCTION IF EXISTS gpGet_User_IsRole (Boolean, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_IsRole(
    IN inisAdmin     Boolean  ,     -- Роль администратор
    IN inUserRole    TBlob    ,     -- Список ролей
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS BOOLEAN AS
$BODY$
   DECLARE vbUserId integer;
   DECLARE vbIndex Integer;
BEGIN
    vbUserId:= lpGetUserBySession (inSession);

    IF inisAdmin = TRUE
    THEN
      IF EXISTS(Select * from gpSelect_Object_UserRole(inSession) Where UserId = vbUserId AND Id = zc_Enum_Role_Admin())
      THEN
          RETURN True;
      END IF;
    END IF;

    -- парсим роли
    vbIndex := 1;
    WHILE TRIM(SPLIT_PART (inUserRole, ',', vbIndex)) <> '' LOOP
        -- проверяем
        IF EXISTS(Select * from gpSelect_Object_UserRole(inSession) Where UserId = vbUserId AND Id IN
                  (Select Object_Role.Id FROM Object AS Object_Role 
                   WHERE Object_Role.DescId = zc_Object_Role()
                     AND Object_Role.isErased = FALSE
                     AND Object_Role.ValueData ILIKE TRIM(SPLIT_PART (inUserRole, ',', vbIndex))))
        THEN
            RETURN True;
        END IF;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;    
    
    RETURN False;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_User_IsAdmin (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.05.23                                                       *
*/
-- 
SELECT * FROM gpGet_User_IsRole (False, 'Инвентаризация', '11097050')
